import java.io.BufferedOutputStream;
import java.io.BufferedInputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.File;
import java.io.FileOutputStream;
import java.net.URL;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;
import java.util.Enumeration;



public class AutoTool {

    // Otra opción es permitir al usuario ingresar una ruta donde crearlo.
    // Validar
    private static final String SONAR_PATH = "C:\\Sonar\\";

    private static final String SONARQ_ZIP_FILE = "SonarQube.zip";
    private static final String SONARQ_OUTPUT_FOLDER = "SonarQube";
    private static final String SONAR_SCANNER_ZIP_FILE = "SonarScanner.zip";
    private static final String SONAR_SCANNER_OUTPUT_FOLDER = "SonarScanner";

    /**
     * saveFile
     * @param url of the file to download
     * @param file name to store downloaded file
     */
    public static void saveFile(URL url, String file) throws IOException {

        System.out.println("Openinig connection...");
        InputStream in = url.openStream();
        FileOutputStream fos = new FileOutputStream(new File(file));

        System.out.println("Reading file...");
        int length = -1;
        byte[] buffer = new byte[1024];
        while ((length = in.read(buffer)) > -1 ) {
            fos.write(buffer, 0, length);
        }

        fos.close();
        in.close();
        System.out.println("File downloaded...");

    }

    /**
     * createFolder
     * @param directory_name name of directory to create
     */
    public void createFolder(String directory_name){

        File folder = new File(directory_name);
        if(!folder.exists()){
            if(folder.mkdir()){
                System.out.println("Directory" + directory_name + "created");
            } else {
                System.out.println("Couldn't create" + directory_name + "directory");
            }
        }
    }

    /**
     * extractFolder
     * @param zipFile name of the directory to unzip
     */
    static public void extractFolder(String zipFile) throws ZipException, IOException 
    {
        System.out.println(zipFile);
        int BUFFER = 2048;
        File file = new File(zipFile);

        ZipFile zip = new ZipFile(file);
        String newPath = zipFile.substring(0, zipFile.length() - 4);
        System.out.println("Newpath "+newPath);
        new File(newPath).mkdir();
        Enumeration zipFileEntries = zip.entries();

        // Process each entry
        while (zipFileEntries.hasMoreElements())
        {
            // grab a zip file entry
            ZipEntry entry = (ZipEntry) zipFileEntries.nextElement();
            String currentEntry = entry.getName();
            File destFile = new File(newPath, currentEntry);
            //destFile = new File(newPath, destFile.getName());
            File destinationParent = destFile.getParentFile();

            // Create the parent directory structure if needed
            destinationParent.mkdirs();

            if (!entry.isDirectory())
            {
                BufferedInputStream is = new BufferedInputStream(zip
                .getInputStream(entry));
                int currentByte;
                // establish buffer for writing file
                byte data[] = new byte[BUFFER];

                // write the current file to disk
                FileOutputStream fos = new FileOutputStream(destFile);
                BufferedOutputStream dest = new BufferedOutputStream(fos,
                BUFFER);

                // read and write until last byte is encountered
                while ((currentByte = is.read(data, 0, BUFFER)) != -1) {
                    dest.write(data, 0, currentByte);
                }
                dest.flush();
                dest.close();
                is.close();
            }

            if (currentEntry.endsWith(".zip"))
            {
                // found a zip file, try to open
                extractFolder(destFile.getAbsolutePath());
            }
        }
    }

    public static void main (String[] args) throws IOException {
        String title = "===========================================\n";
        title += "SonarQube - SonarScanner Automatization\n";
        title += "===========================================\n";
        System.out.println(title);

        File folder = new File(SONAR_PATH);
        if(!folder.exists()){
            folder.mkdir();
        }

        try
        {    
             System.out.println("Downloading Sonar Qube...");
             URL url = new URL("https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.2.zip");
             //String fileName = "C:\\Sonar\\SonarQube.zip";
             String fileName = SONAR_PATH+SONARQ_ZIP_FILE;
             saveFile(url,fileName);
             System.out.println("Downloading Sonar Scanner...");
             url = new URL("https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.8.zip");
             //fileName = "C:\\Sonar\\SonarScanner.zip";
             fileName = SONAR_PATH+SONAR_SCANNER_ZIP_FILE;
             saveFile(url,fileName);
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }

        System.out.println("Extracting " + SONARQ_ZIP_FILE + "..." );
        extractFolder(SONAR_PATH+SONARQ_ZIP_FILE);
        System.out.println(SONARQ_ZIP_FILE+" extracted succesfully");
        System.out.println("Extracting " + SONAR_SCANNER_ZIP_FILE + "...");
        extractFolder(SONAR_PATH+SONAR_SCANNER_ZIP_FILE);
        System.out.println(SONAR_SCANNER_ZIP_FILE+" extracted succesfully");
    }
}