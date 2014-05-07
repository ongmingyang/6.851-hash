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
}
