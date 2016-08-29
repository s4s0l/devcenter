package org.betelgeuse.ci.sample;

import org.junit.Assert;
import org.junit.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.stream.Collectors;
import java.util.zip.GZIPInputStream;
import java.util.zip.Inflater;
import java.util.zip.InflaterInputStream;

/**
 * Created by sasol on 22.07.16.
 */
public class SampleTest {

    @Test
    public void testRest() throws Exception {
//        Thisport isfixed in docker compose so we can check it
        Assert.assertEquals("38080", System.getProperty("web.tcp.80"));
        Assert.assertTrue(System.getProperty("web.host") != null);
        Assert.assertTrue(System.getProperty("lb.host") != null);
//        The load balancer port is not static so we just check if it is null
        Assert.assertNotNull(System.getProperty("lb.tcp.80"));
        Assert.assertTrue(getPage(new URL("http://" + System.getProperty("lb.host") +
                ":" + System.getProperty("lb.tcp.80"))).contains("Hello " +
                "world!"));
    }


    private String getPage(URL url) throws Exception {
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        HttpURLConnection.setFollowRedirects(true);
        conn.setRequestProperty("Accept-Encoding", "gzip, deflate");
        String encoding = conn.getContentEncoding();
        InputStream inStr = null;
        if (encoding != null && encoding.equalsIgnoreCase("gzip")) {
            inStr = new GZIPInputStream(conn.getInputStream());
        } else if (encoding != null && encoding.equalsIgnoreCase("deflate")) {
            inStr = new InflaterInputStream(conn.getInputStream(),
                    new Inflater(true));
        } else {
            inStr = conn.getInputStream();
        }
        try (InputStream inStrx = inStr) {
            return read(inStrx);
        }
    }

    public static String read(InputStream input) throws IOException {
        try (BufferedReader buffer = new BufferedReader(new InputStreamReader(input))) {
            return buffer.lines().collect(Collectors.joining("\n"));
        }
    }
}
