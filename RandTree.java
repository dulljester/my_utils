/*
 */
import java.io.*;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

public class RandTree {

	private static final double tol = 1e-13;
	private static final int N = 25, NONE = -1, MAXIT = 0x400;
	private static final long []T = new long[N]; // T[i] is the number of rooted, 
	private ThreadLocalRandom thr = ThreadLocalRandom.current();
	private Tree oneNode, twoNode;

	private static long calcRecurrence( int m ) {
		if ( m <= 0 )
			return 0L;
		if ( m == 1 )
			return T[m] = 1;
		if ( T[m] == NONE ) {
			T[m] = 0;
			for ( int d = 1; d <= m-1; ++d )
				for ( int j = 1; j*d <= m; T[m] += d*calcRecurrence(m-j*d)*calcRecurrence(d), ++j ) ;
			assert 0 == T[m]%(m-1);
			T[m] /= (m-1);
		}
		return T[m];
	}

	static {
		for ( int k = 0; k < N; T[k++] = NONE ) ;
		calcRecurrence(N-1);
	}

	{
		oneNode = new Tree(1);
		twoNode = new Tree(1); 
		twoNode.addSon(oneNode);
	}

	private Pair randomPair( int n ) {
		double z = (n-1)*T[n]*thr.nextDouble(0,1-tol), TD;
		boolean stop = false;
		Pair res = new Pair(NONE,NONE);
		for ( int d = 1,j,m; !stop; ++d ) 
			for ( TD = d*T[d], m = n, j = 1; (m-=d) >= 1 && !stop; ++j ) 
				if ( (z -= T[m]*TD) < 0 ) {
					stop = true ;
					res.j = j; res.d = d;
				}
		return res;
	}

	public static void main( String [] args ) throws Exception {
		new RandTree().go();
	}

	String makeRColumn( String name, List<Double> x ) {
		StringBuilder sb = new StringBuilder(name + " <- c(");
		for ( int i = 0; i < x.size()-1; ++i )
			sb.append(String.format("%f,",x.get(i)));
		sb.append(String.format("%f)",x.get(x.size()-1)));
		return sb.toString();
	}

	void go() throws Exception {
		double chi = 0,val,iterations = (1<<19);
		List<Double> observed,expected;
		for ( int n = 5; n <= 19; ++n ) {
			observed = new ArrayList<>();
			expected = new ArrayList<>();
			Map<String,Integer> cnt = new HashMap<>();
			chi = 0;
			for ( int it = 0; it < iterations; ++it ) {
				String s = ranrut(n).toString();
				if ( cnt.containsKey(s) ) 
					cnt.put(s,cnt.get(s)+1);
				else cnt.put(s,1);
			}
			int k = 0;
			val = iterations/(T[n]+0.00);
			//System.out.printf("n = %d, #of classes = %d, expected = %.5f\n",n,T[n],expected = (1<<21)/(T[n]+0.00));
			for ( Map.Entry<String,Integer> entry: cnt.entrySet() ) {
				//System.out.printf("%d %d\n",k++,entry.getValue());
				chi += (entry.getValue()-val)*(entry.getValue()-val)/val;
				//observed.add((double)entry.getValue());
				//expected.add(val);
				++k;
			}
			for ( ;k < T[n]; ++k ) {
				//System.out.printf("%d %d\n",k++,0);
				chi += (0-val)*(0-val)/val;
				//observed.add(0.00);
				//expected.add(val);
			}
			//System.out.printf("%.5f\n",chi);
			/*
			assert observed.size() == expected.size();
			String obs = makeRColumn("o",observed);
			String ex  = makeRColumn("e",expected);
			*/
			//System.out.printf("%s\n%s\nchisq.test(x=o,p=e)\n",obs,ex);
			System.out.printf("%f %d\n",chi,T[n]-1);
		}
	}
	
	private Tree ranrut( int n ) {
		assert n >= 1;
		if ( n <= 2 ) 
			return n==1?new Tree(oneNode):new Tree(twoNode);
		assert n >= 3;
		Pair p = randomPair(n);
		assert p.isValid();
		Tree res = ranrut(n-p.j*p.d), td = ranrut(p.d);
		for ( int j = 0; j < p.j; ++j )
			res.addSon(td);
		return res;
	}

	private static class Tree implements Comparable<Tree> {
		private static final String OPENING_BRACKET = "(", CLOSING_BRACKET = ")", LEAF_REPR_BP=OPENING_BRACKET+CLOSING_BRACKET;
		private boolean isNormalized = false;
		private String repr = null;
		private int n;
		private List<Tree> sons = null;
		public int size() { return n; }
		public void addSon( Tree son ) {
			n += son.size();
			sons.add(son);
		}
		Tree( int n ) {
			this.n = n;
			sons = new ArrayList<>();
		}
		Tree( Tree seed ) {
			this.n = 1;
			sons = new ArrayList<>();
			if ( seed.sons != null )
				for ( Tree s: seed.sons )
					this.addSon(s);
		}
		private void normalize() {
			assert n >= 1;
			if ( !isLeaf() && !isNormalized ) {
				assert sons != null;
				for ( Tree s: sons )
					s.normalize();
				Collections.sort(sons);
				isNormalized = true ;
			}
			if ( isLeaf() ) 
				isNormalized = true ;
		}
		public boolean isLeaf() {
			return sons == null || sons.isEmpty();
		}
		private void constructBP( StringBuilder sb ) {
			if ( repr != null ) {
				sb.append(repr);
				return ;
			}
			if ( isLeaf() ) {
				sb.append(LEAF_REPR_BP);
				return ;
			}
			sb.append(OPENING_BRACKET);
			for ( int i = 0; i < (int)sons.size(); sb.append(sons.get(i++).toString()) ) ;
			sb.append(CLOSING_BRACKET);
		}
		@Override
		public String toString() {
			if ( repr == null ) {
				normalize();
				StringBuilder sb = new StringBuilder();
				constructBP(sb);
				repr = sb.toString();
			}
			return repr;
		}
		@Override
		public int compareTo( Tree other ) {
			if ( this.n == other.n ) 
				return toString().compareTo(other.toString());
			return this.n>other.n?-1:1;
		}
	};

	private static class Pair {
		int j,d;
		Pair( int j, int d ) { this.j = j; this.d = d; }
		boolean isValid() { return j != NONE && d != NONE; }
	}
}

