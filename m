Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaIPWCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:02:33 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:51509 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaIPWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:02:31 -0400
From: Jan van den Berg <janvdberg@gmail.com>
To: ibm-acpi@hmh.eng.br
Cc: dvhart@infradead.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan van den Berg <janvdberg@gmail.com>
Subject: [PATCH] x86: thinkpad_acpi.c: fixed spacing coding style issue
Date: Wed, 17 Sep 2014 00:01:08 +0200
Message-Id: <1410904868-10406-1-git-send-email-janvdberg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 22 similar coding style issues: "ERROR: spaces required around that '?'"

Signed-off-by: Jan van den Berg <janvdberg@gmail.com>
---
 drivers/platform/x86/thinkpad_acpi.c | 44 ++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 3bbc6eb..f959978 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3440,7 +3440,7 @@ err_exit:
 	delete_attr_set(hotkey_dev_attributes, &tpacpi_pdev->dev.kobj);
 	hotkey_dev_attributes = NULL;
 
-	return (res < 0)? res : 1;
+	return (res < 0) ? res : 1;
 }
 
 /* Thinkpad X1 Carbon support 5 modes including Home mode, Web browser
@@ -4576,7 +4576,7 @@ static int __init video_init(struct ibm_init_struct *iibm)
 		str_supported(video_supported != TPACPI_VIDEO_NONE),
 		video_supported);
 
-	return (video_supported != TPACPI_VIDEO_NONE)? 0 : 1;
+	return (video_supported != TPACPI_VIDEO_NONE) ? 0 : 1;
 }
 
 static void video_exit(void)
@@ -4669,7 +4669,7 @@ static int video_outputsw_set(int status)
 		return -ENOSYS;
 	}
 
-	return (res)? 0 : -EIO;
+	return (res) ? 0 : -EIO;
 }
 
 static int video_autosw_get(void)
@@ -4695,7 +4695,7 @@ static int video_autosw_get(void)
 
 static int video_autosw_set(int enable)
 {
-	if (!acpi_evalf(vid_handle, NULL, "_DOS", "vd", (enable)? 1 : 0))
+	if (!acpi_evalf(vid_handle, NULL, "_DOS", "vd", (enable) ? 1 : 0))
 		return -EIO;
 	return 0;
 }
@@ -4730,20 +4730,20 @@ static int video_outputsw_cycle(void)
 		return -EIO;
 	}
 
-	return (res)? 0 : -EIO;
+	return (res) ? 0 : -EIO;
 }
 
 static int video_expand_toggle(void)
 {
 	switch (video_supported) {
 	case TPACPI_VIDEO_570:
-		return acpi_evalf(ec_handle, NULL, "_Q17", "v")?
+		return acpi_evalf(ec_handle, NULL, "_Q17", "v") ?
 			0 : -EIO;
 	case TPACPI_VIDEO_770:
-		return acpi_evalf(vid_handle, NULL, "VEXP", "v")?
+		return acpi_evalf(vid_handle, NULL, "VEXP", "v") ?
 			0 : -EIO;
 	case TPACPI_VIDEO_NEW:
-		return acpi_evalf(NULL, NULL, "\\VEXP", "v")?
+		return acpi_evalf(NULL, NULL, "\\VEXP", "v") ?
 			0 : -EIO;
 	default:
 		return -ENOSYS;
@@ -4887,14 +4887,14 @@ static int light_set_status(int status)
 	if (tp_features.light) {
 		if (cmos_handle) {
 			rc = acpi_evalf(cmos_handle, NULL, NULL, "vd",
-					(status)?
+					(status) ?
 						TP_CMOS_THINKLIGHT_ON :
 						TP_CMOS_THINKLIGHT_OFF);
 		} else {
 			rc = acpi_evalf(lght_handle, NULL, NULL, "vd",
-					(status)? 1 : 0);
+					(status) ? 1 : 0);
 		}
-		return (rc)? 0 : -EIO;
+		return (rc) ? 0 : -EIO;
 	}
 
 	return -ENXIO;
@@ -4923,7 +4923,7 @@ static void light_sysfs_set(struct led_classdev *led_cdev,
 
 static enum led_brightness light_sysfs_get(struct led_classdev *led_cdev)
 {
-	return (light_get_status() == 1)? LED_FULL : LED_OFF;
+	return (light_get_status() == 1) ? LED_FULL : LED_OFF;
 }
 
 static struct tpacpi_led_classdev tpacpi_led_thinklight = {
@@ -5045,7 +5045,7 @@ static ssize_t cmos_command_store(struct device *dev,
 		return -EINVAL;
 
 	res = issue_thinkpad_cmos_command(cmos_cmd);
-	return (res)? res : count;
+	return (res) ? res : count;
 }
 
 static struct device_attribute dev_attr_cmos_command =
@@ -5069,7 +5069,7 @@ static int __init cmos_init(struct ibm_init_struct *iibm)
 	if (res)
 		return res;
 
-	return (cmos_handle)? 0 : 1;
+	return (cmos_handle) ? 0 : 1;
 }
 
 static void cmos_exit(void)
@@ -5179,9 +5179,9 @@ static int led_get_status(const unsigned int led)
 		if (!acpi_evalf(ec_handle,
 				&status, "GLED", "dd", 1 << led))
 			return -EIO;
-		led_s = (status == 0)?
+		led_s = (status == 0) ?
 				TPACPI_LED_OFF :
-				((status == 1)?
+				((status == 1) ?
 					TPACPI_LED_ON :
 					TPACPI_LED_BLINK);
 		tpacpi_led_state_cache[led] = led_s;
@@ -5578,7 +5578,7 @@ static int __init beep_init(struct ibm_init_struct *iibm)
 
 	tp_features.beep_needs_two_args = !!(quirks & TPACPI_BEEP_Q1);
 
-	return (beep_handle)? 0 : 1;
+	return (beep_handle) ? 0 : 1;
 }
 
 static int beep_read(struct seq_file *m)
@@ -6527,7 +6527,7 @@ static int brightness_write(char *buf)
 	if (!rc && ibm_backlight_device)
 		backlight_force_update(ibm_backlight_device,
 					BACKLIGHT_UPDATE_SYSFS);
-	return (rc == -EINTR)? -ERESTARTSYS : rc;
+	return (rc == -EINTR) ? -ERESTARTSYS : rc;
 }
 
 static struct ibm_struct brightness_driver_data = {
@@ -7984,7 +7984,7 @@ static ssize_t fan_pwm1_store(struct device *dev,
 	}
 
 	mutex_unlock(&fan_mutex);
-	return (rc)? rc : count;
+	return (rc) ? rc : count;
 }
 
 static struct device_attribute dev_attr_fan_pwm1 =
@@ -8662,7 +8662,7 @@ static const char * __init str_supported(int is_supported)
 {
 	static char text_unsupported[] __initdata = "not supported";
 
-	return (is_supported)? &text_unsupported[4] : &text_unsupported[0];
+	return (is_supported) ? &text_unsupported[4] : &text_unsupported[0];
 }
 #endif /* CONFIG_THINKPAD_ACPI_DEBUG */
 
@@ -8783,7 +8783,7 @@ err_out:
 		ibm->name, ret);
 
 	ibm_exit(ibm);
-	return (ret < 0)? ret : 0;
+	return (ret < 0) ? ret : 0;
 }
 
 /* Probing */
@@ -8794,7 +8794,7 @@ static bool __pure __init tpacpi_is_fw_digit(const char c)
 }
 
 /* Most models: xxyTkkWW (#.##c); Ancient 570/600 and -SL lacks (#.##c) */
-static bool __pure __init tpacpi_is_valid_fw_id(const char* const s,
+static bool __pure __init tpacpi_is_valid_fw_id(const char * const s,
 						const char t)
 {
 	return s && strlen(s) >= 8 &&
-- 
1.9.1

