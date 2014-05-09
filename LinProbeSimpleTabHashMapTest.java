package hashmap;

import static org.junit.Assert.*;

import org.junit.Test;

public class LinProbeSimpleTabHashMapTest {

	@Test
	public void correctlyBreaksIntToBytes(){
		int i1 = Integer.parseInt("101011101010101110101110110110", 2);
		assertEquals(Integer.parseInt("10110110",2), i1 & 255);
		assertEquals(Integer.parseInt("11101011",2), (i1 & (255<<8))>>8);
		assertEquals(Integer.parseInt("10101010",2), (i1 & (255<<16))>>16);
		assertEquals(Integer.parseInt("101011",2), (i1 & (255<<24))>>24);
	}
	
	@Test
	public void lookupTableLoaderWorks(){
		LookupTableLoader l = new LookupTableLoader();
		int[][]tables = l.getTables();
		assertEquals(Integer.toBinaryString(tables[0][0]), "11010111000010110100011001101100");
	}
	
	@Test
	public void lookupTableIsSufficientlyRandom(){
		LookupTableLoader l = new LookupTableLoader();
		int[][]tables = l.getTables();
		int[] simpleTable1 = tables[0];
		int[] simpleTable2 = tables[1];
		int[] simpleTable3 = tables[2];
		int[] simpleTable4 = tables[3];
		System.out.println(hash("6.851".hashCode(), simpleTable1, 
				simpleTable2, simpleTable3, simpleTable4));
		System.out.println(hash("6.852".hashCode(), simpleTable1, 
				simpleTable2, simpleTable3, simpleTable4));
		System.out.println(hash("6.853".hashCode(), simpleTable1, 
				simpleTable2, simpleTable3, simpleTable4));
	}
	
    int hash(int h, int[] simpleTable1, int[]simpleTable2, 
    		int[] simpleTable3, int[] simpleTable4) {
    	int h1 = (h & 255);
    	int h2 = ((h & (255 << 8))>>8);
    	int h3 = ((h & (255 << 16))>>16);
    	int h4 = ((h & (255 << 24))>>24);
    	int i1 = simpleTable1[h1];
    	int i2 = simpleTable2[h2];
    	int i3 = simpleTable3[h3];
    	int i4 = simpleTable4[h4];
    	return i1^i2^i3^i4;
    }
}
