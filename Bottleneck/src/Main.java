import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import java.awt.Font;
import java.awt.Color;
import java.awt.Insets;

public class Main {

	private JFrame f;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Main window = new Main();
					window.f.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public Main() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		f = new JFrame();
		f.setBounds(100, 100, 666, 453);
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		f.getContentPane().setLayout(null);
		
		JMenu menu;  
        JMenuItem i1, i2, i3;  
        JMenuBar mb=new JMenuBar();  
        mb.setMargin(new Insets(1, 1, 1, 1));
        menu=new JMenu("Menu");  
        menu.setForeground(Color.BLACK);
        menu.setBackground(Color.WHITE);
        menu.setFont(new Font("Segoe UI", Font.PLAIN, 30));
        i1=new JMenuItem("PD1 and PD2");  
        i1.setFont(new Font("Segoe UI", Font.PLAIN, 30));
        i2=new JMenuItem("PD1 and PD3");  
        i2.setFont(new Font("Segoe UI", Font.PLAIN, 30));
        i3=new JMenuItem("PD4 and PD5");  
        i3.setFont(new Font("Segoe UI", Font.PLAIN, 30));
        menu.add(i1); menu.add(i2); menu.add(i3);       
        mb.add(menu);  
        f.setJMenuBar(mb);  
        f.setSize(400,400);  
        f.getContentPane().setLayout(null);  
        f.setVisible(true);  
		
		

	}
	
	
}
