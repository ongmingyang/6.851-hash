package hashmap;

import static org.junit.Assert.*;

import org.junit.Test;

public class LinProbeHashMapTest {
	@Test
	public void initializesCorrectly(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		assertNotNull(l);
		assertTrue(l.isEmpty());
		assertEquals(0, l.size());
		assertEquals(12, l.threshold);
		assertEquals(16, l.capacity());
	}
	
	@Test
	public void initializesCapacityCorrectly(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>(200);
		assertNotNull(l);
		assertTrue(l.isEmpty());
		assertEquals(0, l.size());
		assertEquals(192, l.threshold);
		assertEquals(256, l.capacity());
	}
	
	@Test
	public void initializesCapacityAndLoadFactorCorrectly(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>(200,0.375f);
		assertNotNull(l);
		assertTrue(l.isEmpty());
		assertEquals(0, l.size());
		assertEquals(96, l.threshold);
		assertEquals(256, l.capacity());
	}
	
	@Test
	public void addWorks(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		assertNotNull(l);
		l.put("Hello", 1234);
		assertEquals(1,l.size());
		l.put("Hello", 456);
		assertEquals(1,l.size());
		assertEquals((Integer) 456,l.get("Hello"));
		l.remove("Hello");
		assertNull(l.get("Hello"));
		assertTrue(l.isEmpty());
		l.put("Hello", 121);
		l.put("Hella", 234);
		assertEquals(2,l.size());
		l.put("blah",254);
		l.put("welcome",2349);
		l.put("greece", 459);
		l.put("Qwerty",109);
		l.put("dream", 239);
		l.put("retrieve",459);
		l.put("swami", 3489);
		l.put("jfsij", 239);
		l.put("2isjfdsoi",293);
		assertEquals(11,l.size());
		l.put("2930432",3948);
		assertEquals(16, l.capacity());
		l.put("239dk",394);
		assertEquals(32,l.capacity());
	}
	@Test
	public void getWorks(){
		
	}
	@Test
	public void removeWorks(){
		
	}
	@Test
	public void clearWorks(){
		
	}
	@Test
	public void containsKeyWorks(){
		
	}

	@Test
	public void sizeWorks(){
		
	}
	
	@Test
	public void containsValueWorks(){
		
	}
	@Test
	public void isEmptyWorks(){
		
	}
	
	@Test
	public void keySetWorks(){
		
	}
	

	@Test
	public void entrySetWorks(){
		
	}
	
	@Test
	public void putAllWorks(){
		
	}
}
