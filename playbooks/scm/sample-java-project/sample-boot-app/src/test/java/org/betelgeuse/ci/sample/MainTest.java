package org.betelgeuse.ci.sample;

import org.junit.Assert;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by sasol on 23.08.16.
 */
public class MainTest {

    @Test
    public void sampleTest() {
        Assert.assertEquals("Hello World!", new Main().home());
    }

}