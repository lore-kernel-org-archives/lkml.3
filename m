Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbbANMSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:18:36 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:41299 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbbANMSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:18:34 -0500
From: Helene Gsaenger <helene.gsaenger@studium.fau.de>
To: helene.gsaenger@studium.fau.de
Cc: Michael.Hennerich@analog.com, jic23@kernel.org, knaack.h@gmx.de,
        pmeerw@pmeerw.net, gregkh@linuxfoundation.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, simone.weiss@fau.de,
        linux-kernel@i4.cs.fau.de
Subject: [PATCH] staging/iio/accel: checkpatch: fixed long lines by putting comments in seperate lines
Date: Wed, 14 Jan 2015 13:18:10 +0100
Message-Id: <1421237890-18422-1-git-send-email-helene.gsaenger@studium.fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20141227072400.GB4780@sudip-PC>
References: <20141227072400.GB4780@sudip-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
Signed-off-by: Simone Weiss <simone.weiss@fau.de>
---
 drivers/staging/iio/accel/adis16203.h | 99 +++++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/iio/accel/adis16203.h b/drivers/staging/iio/accel/adis16203.h
index acc688d..8d1e200 100644
--- a/drivers/staging/iio/accel/adis16203.h
+++ b/drivers/staging/iio/accel/adis16203.h
@@ -3,43 +3,76 @@
 
 #define ADIS16203_STARTUP_DELAY	220 /* ms */
 
-#define ADIS16203_FLASH_CNT      0x00 /* Flash memory write count */
-#define ADIS16203_SUPPLY_OUT     0x02 /* Output, power supply */
-#define ADIS16203_AUX_ADC        0x08 /* Output, auxiliary ADC input */
-#define ADIS16203_TEMP_OUT       0x0A /* Output, temperature */
-#define ADIS16203_XINCL_OUT      0x0C /* Output, x-axis inclination */
-#define ADIS16203_YINCL_OUT      0x0E /* Output, y-axis inclination */
-#define ADIS16203_INCL_NULL      0x18 /* Incline null calibration */
-#define ADIS16203_ALM_MAG1       0x20 /* Alarm 1 amplitude threshold */
-#define ADIS16203_ALM_MAG2       0x22 /* Alarm 2 amplitude threshold */
-#define ADIS16203_ALM_SMPL1      0x24 /* Alarm 1, sample period */
-#define ADIS16203_ALM_SMPL2      0x26 /* Alarm 2, sample period */
-#define ADIS16203_ALM_CTRL       0x28 /* Alarm control */
-#define ADIS16203_AUX_DAC        0x30 /* Auxiliary DAC data */
-#define ADIS16203_GPIO_CTRL      0x32 /* General-purpose digital input/output control */
-#define ADIS16203_MSC_CTRL       0x34 /* Miscellaneous control */
-#define ADIS16203_SMPL_PRD       0x36 /* Internal sample period (rate) control */
-#define ADIS16203_AVG_CNT        0x38 /* Operation, filter configuration */
-#define ADIS16203_SLP_CNT        0x3A /* Operation, sleep mode control */
-#define ADIS16203_DIAG_STAT      0x3C /* Diagnostics, system status register */
-#define ADIS16203_GLOB_CMD       0x3E /* Operation, system command register */
+/* Flash memory write count */
+#define ADIS16203_FLASH_CNT      0x00
+/* Output, power supply */
+#define ADIS16203_SUPPLY_OUT     0x02
+/* Output, auxiliary ADC input */
+#define ADIS16203_AUX_ADC        0x08
+/* Output, temperature */
+#define ADIS16203_TEMP_OUT       0x0A
+/* Output, x-axis inclination */
+#define ADIS16203_XINCL_OUT      0x0C
+/* Output, y-axis inclination */
+#define ADIS16203_YINCL_OUT      0x0E
+/* Incline null calibration */
+#define ADIS16203_INCL_NULL      0x18
+/* Alarm 1 amplitude threshold */
+#define ADIS16203_ALM_MAG1       0x20
+/* Alarm 2 amplitude threshold */
+#define ADIS16203_ALM_MAG2       0x22
+/* Alarm 1, sample period */
+#define ADIS16203_ALM_SMPL1      0x24
+/* Alarm 2, sample period */
+#define ADIS16203_ALM_SMPL2      0x26
+/* Alarm control */
+#define ADIS16203_ALM_CTRL       0x28
+/* Auxiliary DAC data */
+#define ADIS16203_AUX_DAC        0x30
+/* General-purpose digital input/output control */
+#define ADIS16203_GPIO_CTRL      0x32
+/* Miscellaneous control */
+#define ADIS16203_MSC_CTRL       0x34
+/* Internal sample period (rate) control */
+#define ADIS16203_SMPL_PRD       0x36
+/* Operation, filter configuration */
+#define ADIS16203_AVG_CNT        0x38
+/* Operation, sleep mode control */
+#define ADIS16203_SLP_CNT        0x3A
+/* Diagnostics, system status register */
+#define ADIS16203_DIAG_STAT      0x3C
+/* Operation, system command register */
+#define ADIS16203_GLOB_CMD       0x3E
 
 /* MSC_CTRL */
-#define ADIS16203_MSC_CTRL_PWRUP_SELF_TEST	(1 << 10) /* Self-test at power-on: 1 = disabled, 0 = enabled */
-#define ADIS16203_MSC_CTRL_REVERSE_ROT_EN	(1 << 9)  /* Reverses rotation of both inclination outputs */
-#define ADIS16203_MSC_CTRL_SELF_TEST_EN	        (1 << 8)  /* Self-test enable */
-#define ADIS16203_MSC_CTRL_DATA_RDY_EN	        (1 << 2)  /* Data-ready enable: 1 = enabled, 0 = disabled */
-#define ADIS16203_MSC_CTRL_ACTIVE_HIGH	        (1 << 1)  /* Data-ready polarity: 1 = active high, 0 = active low */
-#define ADIS16203_MSC_CTRL_DATA_RDY_DIO1	(1 << 0)  /* Data-ready line selection: 1 = DIO1, 0 = DIO0 */
+/* Self-test at power-on: 1 = disabled, 0 = enabled */
+#define ADIS16203_MSC_CTRL_PWRUP_SELF_TEST	(1 << 10)
+/* Reverses rotation of both inclination outputs */
+#define ADIS16203_MSC_CTRL_REVERSE_ROT_EN	(1 << 9)
+/* Self-test enable */
+#define ADIS16203_MSC_CTRL_SELF_TEST_EN	        (1 << 8)
+/* Data-ready enable: 1 = enabled, 0 = disabled */
+#define ADIS16203_MSC_CTRL_DATA_RDY_EN	        (1 << 2)
+/* Data-ready polarity: 1 = active high, 0 = active low */
+#define ADIS16203_MSC_CTRL_ACTIVE_HIGH	        (1 << 1)
+/* Data-ready line selection: 1 = DIO1, 0 = DIO0 */
+#define ADIS16203_MSC_CTRL_DATA_RDY_DIO1	(1 << 0)
 
 /* DIAG_STAT */
-#define ADIS16203_DIAG_STAT_ALARM2        (1<<9) /* Alarm 2 status: 1 = alarm active, 0 = alarm inactive */
-#define ADIS16203_DIAG_STAT_ALARM1        (1<<8) /* Alarm 1 status: 1 = alarm active, 0 = alarm inactive */
-#define ADIS16203_DIAG_STAT_SELFTEST_FAIL_BIT 5 /* Self-test diagnostic error flag */
-#define ADIS16203_DIAG_STAT_SPI_FAIL_BIT      3 /* SPI communications failure */
-#define ADIS16203_DIAG_STAT_FLASH_UPT_BIT     2 /* Flash update failure */
-#define ADIS16203_DIAG_STAT_POWER_HIGH_BIT    1 /* Power supply above 3.625 V */
-#define ADIS16203_DIAG_STAT_POWER_LOW_BIT     0 /* Power supply below 3.15 V */
+/* Alarm 2 status: 1 = alarm active, 0 = alarm inactive */
+#define ADIS16203_DIAG_STAT_ALARM2        (1<<9)
+/* Alarm 1 status: 1 = alarm active, 0 = alarm inactive */
+#define ADIS16203_DIAG_STAT_ALARM1        (1<<8)
+/* Self-test diagnostic error flag */
+#define ADIS16203_DIAG_STAT_SELFTEST_FAIL_BIT 5
+/* SPI communications failure */
+#define ADIS16203_DIAG_STAT_SPI_FAIL_BIT      3
+/* Flash update failure */
+#define ADIS16203_DIAG_STAT_FLASH_UPT_BIT     2
+/* Power supply above 3.625 V */
+#define ADIS16203_DIAG_STAT_POWER_HIGH_BIT    1
+/* Power supply below 3.15 V */
+#define ADIS16203_DIAG_STAT_POWER_LOW_BIT     0
 
 /* GLOB_CMD */
 #define ADIS16203_GLOB_CMD_SW_RESET	(1<<7)
-- 
1.9.1

