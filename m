Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaLVBc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:32:27 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58814 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbaLVBc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:32:26 -0500
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Dec 2014 20:32:25 EST
From: Helene Gsaenger <helene.gsaenger@studium.fau.de>
To: helene.gsaenger@studium.fau.de
Cc: simone.weiss@fau.de, linux-kernel@i4.cs.fau.de, lars@metafoo.de,
        Michael.Hennerich@analog.com, jic23@kernel.org, knaack.h@gmx.de,
        pmeerw@pmeerw.net, gregkh@linuxfoundation.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/iio/accel: checkpatch: fixed long lines by moving comments
Date: Mon, 22 Dec 2014 02:23:42 +0100
Message-Id: <1419211422-9611-1-git-send-email-helene.gsaenger@studium.fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
Signed-off-by: Simone Weiss <simone.weiss@fau.de>
---
 drivers/staging/iio/accel/adis16203.h | 41 ++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/iio/accel/adis16203.h b/drivers/staging/iio/accel/adis16203.h
index acc688d..fefe2f9 100644
--- a/drivers/staging/iio/accel/adis16203.h
+++ b/drivers/staging/iio/accel/adis16203.h
@@ -16,26 +16,47 @@
 #define ADIS16203_ALM_SMPL2      0x26 /* Alarm 2, sample period */
 #define ADIS16203_ALM_CTRL       0x28 /* Alarm control */
 #define ADIS16203_AUX_DAC        0x30 /* Auxiliary DAC data */
-#define ADIS16203_GPIO_CTRL      0x32 /* General-purpose digital input/output control */
+#define ADIS16203_GPIO_CTRL      0x32 /* General-purpose digital input/output
+				       * control */
 #define ADIS16203_MSC_CTRL       0x34 /* Miscellaneous control */
-#define ADIS16203_SMPL_PRD       0x36 /* Internal sample period (rate) control */
+#define ADIS16203_SMPL_PRD       0x36 /* Internal sample period (rate)
+				       * control */
 #define ADIS16203_AVG_CNT        0x38 /* Operation, filter configuration */
 #define ADIS16203_SLP_CNT        0x3A /* Operation, sleep mode control */
 #define ADIS16203_DIAG_STAT      0x3C /* Diagnostics, system status register */
 #define ADIS16203_GLOB_CMD       0x3E /* Operation, system command register */
 
 /* MSC_CTRL */
-#define ADIS16203_MSC_CTRL_PWRUP_SELF_TEST	(1 << 10) /* Self-test at power-on: 1 = disabled, 0 = enabled */
-#define ADIS16203_MSC_CTRL_REVERSE_ROT_EN	(1 << 9)  /* Reverses rotation of both inclination outputs */
+#define ADIS16203_MSC_CTRL_PWRUP_SELF_TEST	(1 << 10) /* Self-test at
+							   * power-on:
+							   * 1 = disabled,
+							   * 0 = enabled */
+#define ADIS16203_MSC_CTRL_REVERSE_ROT_EN	(1 << 9)  /* Reverses rotation
+							   * of both
+							   * inclination
+							   * outputs */
 #define ADIS16203_MSC_CTRL_SELF_TEST_EN	        (1 << 8)  /* Self-test enable */
-#define ADIS16203_MSC_CTRL_DATA_RDY_EN	        (1 << 2)  /* Data-ready enable: 1 = enabled, 0 = disabled */
-#define ADIS16203_MSC_CTRL_ACTIVE_HIGH	        (1 << 1)  /* Data-ready polarity: 1 = active high, 0 = active low */
-#define ADIS16203_MSC_CTRL_DATA_RDY_DIO1	(1 << 0)  /* Data-ready line selection: 1 = DIO1, 0 = DIO0 */
+#define ADIS16203_MSC_CTRL_DATA_RDY_EN	        (1 << 2)  /* Data-ready enable:
+							   * 1 = enabled,
+							   * 0 = disabled */
+#define ADIS16203_MSC_CTRL_ACTIVE_HIGH	        (1 << 1)  /* Data-ready
+							   * polarity:
+							   * 1 = active high,
+							   * 0 = active low */
+#define ADIS16203_MSC_CTRL_DATA_RDY_DIO1	(1 << 0)  /* Data-ready line
+							   * selection:
+							   * 1 = DIO1,
+							   * 0 = DIO0 */
 
 /* DIAG_STAT */
-#define ADIS16203_DIAG_STAT_ALARM2        (1<<9) /* Alarm 2 status: 1 = alarm active, 0 = alarm inactive */
-#define ADIS16203_DIAG_STAT_ALARM1        (1<<8) /* Alarm 1 status: 1 = alarm active, 0 = alarm inactive */
-#define ADIS16203_DIAG_STAT_SELFTEST_FAIL_BIT 5 /* Self-test diagnostic error flag */
+#define ADIS16203_DIAG_STAT_ALARM2        (1<<9) /* Alarm 2 status:
+						  * 1 = alarm active,
+						  * 0 = alarm inactive */
+#define ADIS16203_DIAG_STAT_ALARM1        (1<<8) /* Alarm 1 status:
+						  * 1 = alarm active,
+						  * 0 = alarm inactive */
+#define ADIS16203_DIAG_STAT_SELFTEST_FAIL_BIT 5 /* Self-test diagnostic error
+						 * flag */
 #define ADIS16203_DIAG_STAT_SPI_FAIL_BIT      3 /* SPI communications failure */
 #define ADIS16203_DIAG_STAT_FLASH_UPT_BIT     2 /* Flash update failure */
 #define ADIS16203_DIAG_STAT_POWER_HIGH_BIT    1 /* Power supply above 3.625 V */
-- 
1.9.1

