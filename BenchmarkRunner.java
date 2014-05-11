package hashmap;

import java.util.HashMap;
import java.util.Random;

import org.apache.commons.lang3.RandomStringUtils;

import bb.util.Benchmark;

public class BenchmarkRunner {

	public static void main(String[] args) {
		final int ops = Integer.parseInt(args[1]);
		LookupTableLoader tables = new LookupTableLoader();
		final int[] t1 = tables.getTables()[0];
		final int[] t2 = tables.getTables()[1];
		final int[] t3 = tables.getTables()[2];
		final int[] t4 = tables.getTables()[3];
		Runnable task;
		switch(args[0]){
		case "simpleTableInsert":
			task = new Runnable(){
				public void run(){
					SimpleTabHashMap<String, Integer> l = 
							new SimpleTabHashMap<String, Integer>(t1,t2,t3,t4);
					Random r = new Random();
					for (int i = 0; i < ops; i++){
						l.put(RandomStringUtils.random(8), r.nextInt());
					}
				}
			};
			System.out.println("simpletab: " + new Benchmark(task));
		case "linProbeSimpleTabInsert":
			task = new Runnable(){
				public void run(){
					LinProbeSimpleTabHashMap<String, Integer> l = 
							new LinProbeSimpleTabHashMap<String, Integer>(t1,t2,t3,t4);
					Random r = new Random();
					for (int i = 0; i < ops; i++){
						l.put(RandomStringUtils.random(8), r.nextInt());
					}
				}
			};
			System.out.println("linprobesimpletab: " + new Benchmark(task));
		break;
		case "linProbeInsert":
			task = new Runnable(){
				public void run(){
					LinProbeHashMap<String, Integer> l = 
							new LinProbeHashMap<String, Integer>();
					Random r = new Random();
					for (int i = 0; i < ops; i++){
						l.put(RandomStringUtils.random(8), r.nextInt());
					}
				}
			};
			System.out.println("linprobe: " + new Benchmark(task));
		break;
		case "default":
			task = new Runnable(){
				public void run(){
					HashMap<String, Integer> h = 
							new HashMap<String, Integer>();
					Random r = new Random();
					for (int i = 0; i < ops; i++){
						h.put(RandomStringUtils.random(8), r.nextInt());
					}
				}
			};
			System.out.println("default: " + new Benchmark(task));
		break;
		default: break;
		}		
	}
	
}
