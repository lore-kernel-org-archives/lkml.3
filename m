Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792Ab3DHRHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:07:09 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43830 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934191Ab3DHRHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:07:07 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: joe@perches.com, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] [trivial]treewide: Fix typo in printks
Date: Tue,  9 Apr 2013 02:06:50 +0900
Message-Id: <1365440810-25964-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2.451.gbfd70c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos in printk and comments.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

---
 drivers/media/pci/saa7164/saa7164-core.c | 2 +-
 drivers/rtc/Kconfig                      | 4 ++--
 drivers/rtc/rtc-max8997.c                | 2 +-
 drivers/usb/misc/iowarrior.c             | 4 ++--
 drivers/usb/misc/uss720.c                | 2 +-
 drivers/video/amifb.c                    | 2 +-
 drivers/video/auo_k190x.c                | 2 +-
 drivers/video/goldfishfb.c               | 2 +-
 drivers/video/s1d13xxxfb.c               | 2 +-
 drivers/video/ssd1307fb.c                | 4 ++--
 fs/nfs/objlayout/objio_osd.c             | 2 +-
 fs/nfs/objlayout/objlayout.h             | 2 +-
 sound/soc/codecs/wm8974.c                | 2 +-
 tools/perf/tests/attr.c                  | 2 +-
 tools/perf/tests/parse-events.c          | 2 +-
 15 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 63502e7..7618fda 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -54,7 +54,7 @@ MODULE_PARM_DESC(debug, "enable debug messages");
 
 unsigned int fw_debug;
 module_param(fw_debug, int, 0644);
-MODULE_PARM_DESC(fw_debug, "Firware debug level def:2");
+MODULE_PARM_DESC(fw_debug, "Firmware debug level def:2");
 
 unsigned int encoder_buffers = SAA7164_MAX_ENCODER_BUFFERS;
 module_param(encoder_buffers, int, 0644);
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 79fbe38..0c81915 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -402,7 +402,7 @@ config RTC_DRV_TPS6586X
 	tristate "TI TPS6586X RTC driver"
 	depends on MFD_TPS6586X
 	help
-	  TI Power Managment IC TPS6586X supports RTC functionality
+	  TI Power Management IC TPS6586X supports RTC functionality
 	  along with alarm. This driver supports the RTC driver for
 	  the TPS6586X RTC module.
 
@@ -420,7 +420,7 @@ config RTC_DRV_TPS80031
 	tristate "TI TPS80031/TPS80032 RTC driver"
 	depends on MFD_TPS80031
 	help
-	  TI Power Managment IC TPS80031 supports RTC functionality
+	  TI Power Management IC TPS80031 supports RTC functionality
 	  along with alarm. This driver supports the RTC driver for
 	  the TPS80031 RTC module.
 
diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
index 00e505b..f15202c 100644
--- a/drivers/rtc/rtc-max8997.c
+++ b/drivers/rtc/rtc-max8997.c
@@ -24,7 +24,7 @@
 /* Module parameter for WTSR function control */
 static int wtsr_en = 1;
 module_param(wtsr_en, int, 0444);
-MODULE_PARM_DESC(wtsr_en, "Wachdog Timeout & Sofware Reset (default=on)");
+MODULE_PARM_DESC(wtsr_en, "Watchdog Timeout & Software Reset (default=on)");
 /* Module parameter for SMPL function control */
 static int smpl_en = 1;
 module_param(smpl_en, int, 0444);
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index db46143..d36f34e 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -672,7 +672,7 @@ static int iowarrior_release(struct inode *inode, struct file *file)
 		retval = -ENODEV;	/* close called more than once */
 		mutex_unlock(&dev->mutex);
 	} else {
-		dev->opened = 0;	/* we're closeing now */
+		dev->opened = 0;	/* we're closing now */
 		retval = 0;
 		if (dev->present) {
 			/*
@@ -802,7 +802,7 @@ static int iowarrior_probe(struct usb_interface *interface,
 			/* this one will match for the IOWarrior56 only */
 			dev->int_out_endpoint = endpoint;
 	}
-	/* we have to check the report_size often, so remember it in the endianess suitable for our machine */
+	/* we have to check the report_size often, so remember it in the endianness suitable for our machine */
 	dev->report_size = usb_endpoint_maxp(dev->int_in_endpoint);
 	if ((dev->interface->cur_altsetting->desc.bInterfaceNumber == 0) &&
 	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56))
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 29cad9e..e129cf6 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -705,7 +705,7 @@ static int uss720_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 	i = usb_set_interface(usbdev, intf->altsetting->desc.bInterfaceNumber, 2);
-	dev_dbg(&intf->dev, "set inteface result %d\n", i);
+	dev_dbg(&intf->dev, "set interface result %d\n", i);
 
 	interface = intf->cur_altsetting;
 
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index 7fa1bf8..87b2bb3 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -1181,7 +1181,7 @@ static int ami_decode_var(struct fb_var_screeninfo *var, struct amifb_par *par,
 	}
 
 	/*
-	 * FB_VMODE_SMOOTH_XPAN will be cleared, if one of the folloing
+	 * FB_VMODE_SMOOTH_XPAN will be cleared, if one of the following
 	 * checks failed and smooth scrolling is not possible
 	 */
 
diff --git a/drivers/video/auo_k190x.c b/drivers/video/auo_k190x.c
index 53846cb..47e6770 100644
--- a/drivers/video/auo_k190x.c
+++ b/drivers/video/auo_k190x.c
@@ -935,7 +935,7 @@ int auok190x_common_probe(struct platform_device *pdev,
 		goto err_defio;
 	}
 
-	dev_dbg(info->device, "targetting %d frames per second\n", board->fps);
+	dev_dbg(info->device, "targeting %d frames per second\n", board->fps);
 	info->fbdefio->delay = HZ / board->fps;
 	info->fbdefio->first_io = auok190xfb_dpy_first_io,
 	info->fbdefio->deferred_io = auok190xfb_dpy_deferred_io,
diff --git a/drivers/video/goldfishfb.c b/drivers/video/goldfishfb.c
index 489abb3..7f6c9e6 100644
--- a/drivers/video/goldfishfb.c
+++ b/drivers/video/goldfishfb.c
@@ -148,7 +148,7 @@ static int goldfish_fb_pan_display(struct fb_var_screeninfo *var,
 	wait_event_timeout(fb->wait,
 			fb->base_update_count != base_update_count, HZ / 15);
 	if (fb->base_update_count == base_update_count)
-		pr_err("goldfish_fb_pan_display: timeout wating for base update\n");
+		pr_err("goldfish_fb_pan_display: timeout waiting for base update\n");
 	return 0;
 }
 
diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/s1d13xxxfb.c
index 76d9053..05c2dc3 100644
--- a/drivers/video/s1d13xxxfb.c
+++ b/drivers/video/s1d13xxxfb.c
@@ -862,7 +862,7 @@ static int s1d13xxxfb_probe(struct platform_device *pdev)
 		printk(KERN_INFO PFX
 			"unknown chip production id %i, revision %i\n",
 			prod_id, revision);
-		printk(KERN_INFO PFX "please contant maintainer\n");
+		printk(KERN_INFO PFX "please contact maintainer\n");
 		goto bail;
 	}
 
diff --git a/drivers/video/ssd1307fb.c b/drivers/video/ssd1307fb.c
index 395cb6a..9ef05d3 100644
--- a/drivers/video/ssd1307fb.c
+++ b/drivers/video/ssd1307fb.c
@@ -1,5 +1,5 @@
 /*
- * Driver for the Solomon SSD1307 OLED controler
+ * Driver for the Solomon SSD1307 OLED controller
  *
  * Copyright 2012 Free Electrons
  *
@@ -392,6 +392,6 @@ static struct i2c_driver ssd1307fb_driver = {
 
 module_i2c_driver(ssd1307fb_driver);
 
-MODULE_DESCRIPTION("FB driver for the Solomon SSD1307 OLED controler");
+MODULE_DESCRIPTION("FB driver for the Solomon SSD1307 OLED controller");
 MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com>");
 MODULE_LICENSE("GPL");
diff --git a/fs/nfs/objlayout/objio_osd.c b/fs/nfs/objlayout/objio_osd.c
index 88f9611..5457745 100644
--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -234,7 +234,7 @@ static int __alloc_objio_seg(unsigned numdevs, gfp_t gfp_flags,
 
 	lseg = kzalloc(lseg_size, gfp_flags);
 	if (unlikely(!lseg)) {
-		dprintk("%s: Faild allocation numdevs=%d size=%zd\n", __func__,
+		dprintk("%s: Failed allocation numdevs=%d size=%zd\n", __func__,
 			numdevs, lseg_size);
 		return -ENOMEM;
 	}
diff --git a/fs/nfs/objlayout/objlayout.h b/fs/nfs/objlayout/objlayout.h
index 880ba08..87aa1de 100644
--- a/fs/nfs/objlayout/objlayout.h
+++ b/fs/nfs/objlayout/objlayout.h
@@ -114,7 +114,7 @@ extern int objio_alloc_lseg(struct pnfs_layout_segment **outp,
 	gfp_t gfp_flags);
 extern void objio_free_lseg(struct pnfs_layout_segment *lseg);
 
-/* objio_free_result will free these @oir structs recieved from
+/* objio_free_result will free these @oir structs received from
  * objlayout_{read,write}_done
  */
 extern void objio_free_result(struct objlayout_io_res *oir);
diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index b47c252..a2d01d1 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -125,7 +125,7 @@ SOC_ENUM("Equaliser EQ4 Bandwidth", wm8974_enum[9]),
 SOC_ENUM("EQ4 Cut Off", wm8974_enum[10]),
 SOC_SINGLE_TLV("EQ4 Volume", WM8974_EQ4,  0, 24, 1, eq_tlv),
 
-SOC_ENUM("Equaliser EQ5 Bandwith", wm8974_enum[11]),
+SOC_ENUM("Equaliser EQ5 Bandwidth", wm8974_enum[11]),
 SOC_ENUM("EQ5 Cut Off", wm8974_enum[12]),
 SOC_SINGLE_TLV("EQ5 Volume", WM8974_EQ5,  0, 24, 1, eq_tlv),
 
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index bdcceb8..e825732 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -173,6 +173,6 @@ int test__attr(void)
 	    !lstat(path_perf, &st))
 		return run_dir(path_dir, path_perf);
 
-	fprintf(stderr, " (ommitted)");
+	fprintf(stderr, " (omitted)");
 	return 0;
 }
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index c5636f3..63986f9 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1321,7 +1321,7 @@ static int test_pmu_events(void)
 
 	ret = stat(path, &st);
 	if (ret) {
-		pr_debug("ommiting PMU cpu events tests\n");
+		pr_debug("omitting PMU cpu events tests\n");
 		return 0;
 	}
 
-- 
1.8.2.451.gbfd70c5

