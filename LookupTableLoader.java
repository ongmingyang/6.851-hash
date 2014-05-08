package hashmap;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class LookupTableLoader {
	private int[][] tables;
	
	public LookupTableLoader(String filename){
		tables = new int[4][256];
		try {
			BufferedInputStream in = new BufferedInputStream(new FileInputStream(filename));
			convertToLookupTable(in);
			in.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public LookupTableLoader(){
		this("converted_bytes");
	}
	public int[][] getTables(){
		return tables;
	}
	
	private void convertToLookupTable(InputStream in){
		for (int i = 0; i < 4; i++){
			for(int j = 0; j < 256; j++){
				try {
					int b1 = in.read() << 24;
					int b2 = in.read() << 16;
					int b3 = in.read() << 8;
					int b4 = in.read();
					tables[i][j] = b1+b2+b3+b4;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
}
