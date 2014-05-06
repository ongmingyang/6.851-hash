package hashmap;

import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

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
		l.put("Hello", 1234);
		assertEquals(1,l.size());
		//inputting something with the same key should 
		//override the value
		l.put("Hello", 456);
		assertEquals(1,l.size());
		assertEquals((Integer) 456,l.get("Hello"));
		l.remove("Hello");
		assertNull(l.get("Hello"));
		//add should work properly even after deletion
		l.put("Hello", 121);
		assertEquals((Integer) 121,l.get("Hello"));
		l.put("Hella", 234);
		assertEquals(2,l.size());
	}
	@Test
	public void getWorks(){
		
	}
	@Test
	public void removeWorks(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		l.put("Hello", 456);
		assertEquals(1,l.size());
		assertEquals((Integer)456, l.remove("Hello"));
		assertNull(l.get("Hello"));
		assertTrue(l.isEmpty());
		assertEquals(0,l.size());
		assertNull(l.remove("Hello"));
	}
	@Test
	public void clearWorks(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		l.put("blah",254);
		l.put("welcome",2349);
		l.put("greece", 459);
		l.put("Qwerty",109);
		l.put("dream", 239);
		l.put("retrieve",459);
		l.put("swami", 3489);
		l.put("jfsij", 239);
		l.put("2isjfdsoi",293);
		l.clear();
		assertTrue(l.isEmpty());
		assertEquals(l.size(),0);
	}
	@Test
	public void containsKeyWorks(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		l.put("blah",254);
		l.put("welcome",2349);
		l.put("greece", 459);
		l.put("Qwerty",109);
		assertTrue(l.containsKey("blah"));
		assertTrue(l.containsKey("welcome"));
		assertFalse(l.containsKey("Qwert"));
	}

	@Test
	public void sizeWorks(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		l.put("Hello", 121);
		assertEquals((Integer) 121,l.get("Hello"));
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
		assertEquals(13,l.size());
		assertEquals(32,l.capacity());
	}
	
	@Test
	public void containsValueWorks(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		l.put("blah",254);
		l.put("welcome",2349);
		l.put("greece", 459);
		l.put("Qwerty",109);
		assertTrue(l.containsValue(new Integer(254)));
		assertTrue(l.containsValue(new Integer(459)));
		assertFalse(l.containsValue(new Integer(219)));
	}
	@Test
	public void isEmptyWorks(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		assertTrue(l.isEmpty());
		l.put("Hello", 456);
		assertEquals(1,l.size());
		assertEquals((Integer) 456,l.get("Hello"));
		l.remove("Hello");		
		assertTrue(l.isEmpty());
		
	}
	
	@Test
	public void keySetWorks(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		l.put("blah",254);
		l.put("welcome",2349);
		l.put("greece", 459);
		l.put("Qwerty",109);
		Set<String> s = l.keySet();
		assertTrue(s.contains("blah"));
		assertTrue(s.contains("welcome"));
		assertTrue(s.contains("greece"));
		assertFalse(s.contains("hello"));
	}
	

	@Test
	public void entrySetWorks(){
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		l.put("blah",254);
		l.put("welcome",2349);
		l.put("greece", 459);
		l.put("Qwerty",109);
		Set<Map.Entry<String, Integer>> s = l.entrySet();
		Iterator<Map.Entry<String,Integer>> it = s.iterator();
		Map.Entry<String, Integer> m = it.next();
		assertTrue(m.getValue().equals(new Integer(254)) || 
				m.getValue().equals(new Integer(2349)) ||
				m.getValue().equals(new Integer(459)) ||
				m.getValue().equals(new Integer(109)));
		assertTrue(m.getKey().equals("blah") || 
				m.getKey().equals("welcome") ||
				m.getKey().equals("greece") ||
				m.getKey().equals("Qwerty"));
	}
	
	@Test
	public void putAllWorks(){
		HashMap<String,Integer> h = new HashMap<String,Integer>();
		h.put("blah",254);
		h.put("welcome",2349);
		h.put("greece", 459);
		h.put("Qwerty",109);
		LinProbeHashMap<String, Integer> l = new LinProbeHashMap<String, Integer>();
		l.putAll(h);
		assertTrue(l.containsValue(254));
		assertTrue(l.containsValue(2349));
		assertFalse(l.containsKey("hello"));
		assertTrue(l.containsKey("greece"));
		assertFalse(l.containsValue(483));
	}
}
