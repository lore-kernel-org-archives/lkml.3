Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab3IJMyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:54:39 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42884 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3IJMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 23/38] iio: pressure-core: st: Describe LPS331AP defines by name
Date: Tue, 10 Sep 2013 13:49:24 +0100
Message-Id: <1378817379-8238-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're currently named *_1_*, for 'Sensor 1', but the code will be much
more readable if we use the naming convention *_LPS331AP_* instead.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/pressure/st_pressure_core.c | 94 ++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index 279aafd..2ee4bcd 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -36,94 +36,92 @@
 						 ST_PRESS_LSB_PER_CELSIUS)
 #define ST_PRESS_NUMBER_DATA_CHANNELS		1
 
-/* DEFAULT VALUE FOR SENSORS */
-#define ST_PRESS_DEFAULT_OUT_XL_ADDR		0x28
-#define ST_TEMP_DEFAULT_OUT_L_ADDR		0x2b
-
 /* FULLSCALE */
 #define ST_PRESS_FS_AVL_1260MB			1260
 
-/* CUSTOM VALUES FOR SENSOR 1 */
-#define ST_PRESS_1_WAI_EXP			0xbb
-#define ST_PRESS_1_ODR_ADDR			0x20
-#define ST_PRESS_1_ODR_MASK			0x70
-#define ST_PRESS_1_ODR_AVL_1HZ_VAL		0x01
-#define ST_PRESS_1_ODR_AVL_7HZ_VAL		0x05
-#define ST_PRESS_1_ODR_AVL_13HZ_VAL		0x06
-#define ST_PRESS_1_ODR_AVL_25HZ_VAL		0x07
-#define ST_PRESS_1_PW_ADDR			0x20
-#define ST_PRESS_1_PW_MASK			0x80
-#define ST_PRESS_1_FS_ADDR			0x23
-#define ST_PRESS_1_FS_MASK			0x30
-#define ST_PRESS_1_FS_AVL_1260_VAL		0x00
-#define ST_PRESS_1_FS_AVL_1260_GAIN		ST_PRESS_KPASCAL_NANO_SCALE
-#define ST_PRESS_1_FS_AVL_TEMP_GAIN		ST_PRESS_CELSIUS_NANO_SCALE
-#define ST_PRESS_1_BDU_ADDR			0x20
-#define ST_PRESS_1_BDU_MASK			0x04
-#define ST_PRESS_1_DRDY_IRQ_ADDR		0x22
-#define ST_PRESS_1_DRDY_IRQ_INT1_MASK		0x04
-#define ST_PRESS_1_DRDY_IRQ_INT2_MASK		0x20
-#define ST_PRESS_1_MULTIREAD_BIT		true
-#define ST_PRESS_1_TEMP_OFFSET			42500
+/* CUSTOM VALUES FOR LPS331AP SENSOR */
+#define ST_PRESS_LPS331AP_WAI_EXP		0xbb
+#define ST_PRESS_LPS331AP_ODR_ADDR		0x20
+#define ST_PRESS_LPS331AP_ODR_MASK		0x70
+#define ST_PRESS_LPS331AP_ODR_AVL_1HZ_VAL	0x01
+#define ST_PRESS_LPS331AP_ODR_AVL_7HZ_VAL	0x05
+#define ST_PRESS_LPS331AP_ODR_AVL_13HZ_VAL	0x06
+#define ST_PRESS_LPS331AP_ODR_AVL_25HZ_VAL	0x07
+#define ST_PRESS_LPS331AP_PW_ADDR		0x20
+#define ST_PRESS_LPS331AP_PW_MASK		0x80
+#define ST_PRESS_LPS331AP_FS_ADDR		0x23
+#define ST_PRESS_LPS331AP_FS_MASK		0x30
+#define ST_PRESS_LPS331AP_FS_AVL_1260_VAL	0x00
+#define ST_PRESS_LPS331AP_FS_AVL_1260_GAIN	ST_PRESS_KPASCAL_NANO_SCALE
+#define ST_PRESS_LPS331AP_FS_AVL_TEMP_GAIN	ST_PRESS_CELSIUS_NANO_SCALE
+#define ST_PRESS_LPS331AP_BDU_ADDR		0x20
+#define ST_PRESS_LPS331AP_BDU_MASK		0x04
+#define ST_PRESS_LPS331AP_DRDY_IRQ_ADDR		0x22
+#define ST_PRESS_LPS331AP_DRDY_IRQ_INT1_MASK	0x04
+#define ST_PRESS_LPS331AP_DRDY_IRQ_INT2_MASK	0x20
+#define ST_PRESS_LPS331AP_MULTIREAD_BIT		true
+#define ST_PRESS_LPS331AP_TEMP_OFFSET		42500
+#define ST_PRESS_LPS331AP_OUT_XL_ADDR		0x28
+#define ST_TEMP_LPS331AP_OUT_L_ADDR		0x2b
 
 static const struct iio_chan_spec st_press_channels[] = {
 	ST_SENSORS_LSM_CHANNELS(IIO_PRESSURE,
 			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE),
 			ST_SENSORS_SCAN_X, 0, IIO_NO_MOD, 'u', IIO_LE, 24, 24,
-			ST_PRESS_DEFAULT_OUT_XL_ADDR),
+			ST_PRESS_LPS331AP_OUT_XL_ADDR),
 	ST_SENSORS_LSM_CHANNELS(IIO_TEMP,
 			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE) |
 						BIT(IIO_CHAN_INFO_OFFSET),
 			-1, 0, IIO_NO_MOD, 's', IIO_LE, 16, 16,
-			ST_TEMP_DEFAULT_OUT_L_ADDR),
+			ST_TEMP_LPS331AP_OUT_L_ADDR),
 	IIO_CHAN_SOFT_TIMESTAMP(1)
 };
 
 static const struct st_sensors st_press_sensors[] = {
 	{
-		.wai = ST_PRESS_1_WAI_EXP,
+		.wai = ST_PRESS_LPS331AP_WAI_EXP,
 		.sensors_supported = {
 			[0] = LPS331AP_PRESS_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_press_channels,
 		.odr = {
-			.addr = ST_PRESS_1_ODR_ADDR,
-			.mask = ST_PRESS_1_ODR_MASK,
+			.addr = ST_PRESS_LPS331AP_ODR_ADDR,
+			.mask = ST_PRESS_LPS331AP_ODR_MASK,
 			.odr_avl = {
-				{ 1, ST_PRESS_1_ODR_AVL_1HZ_VAL, },
-				{ 7, ST_PRESS_1_ODR_AVL_7HZ_VAL, },
-				{ 13, ST_PRESS_1_ODR_AVL_13HZ_VAL, },
-				{ 25, ST_PRESS_1_ODR_AVL_25HZ_VAL, },
+				{ 1, ST_PRESS_LPS331AP_ODR_AVL_1HZ_VAL, },
+				{ 7, ST_PRESS_LPS331AP_ODR_AVL_7HZ_VAL, },
+				{ 13, ST_PRESS_LPS331AP_ODR_AVL_13HZ_VAL, },
+				{ 25, ST_PRESS_LPS331AP_ODR_AVL_25HZ_VAL, },
 			},
 		},
 		.pw = {
-			.addr = ST_PRESS_1_PW_ADDR,
-			.mask = ST_PRESS_1_PW_MASK,
+			.addr = ST_PRESS_LPS331AP_PW_ADDR,
+			.mask = ST_PRESS_LPS331AP_PW_MASK,
 			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
 			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
 		},
 		.fs = {
-			.addr = ST_PRESS_1_FS_ADDR,
-			.mask = ST_PRESS_1_FS_MASK,
+			.addr = ST_PRESS_LPS331AP_FS_ADDR,
+			.mask = ST_PRESS_LPS331AP_FS_MASK,
 			.fs_avl = {
 				[0] = {
 					.num = ST_PRESS_FS_AVL_1260MB,
-					.value = ST_PRESS_1_FS_AVL_1260_VAL,
-					.gain = ST_PRESS_1_FS_AVL_1260_GAIN,
-					.gain2 = ST_PRESS_1_FS_AVL_TEMP_GAIN,
+					.value = ST_PRESS_LPS331AP_FS_AVL_1260_VAL,
+					.gain = ST_PRESS_LPS331AP_FS_AVL_1260_GAIN,
+					.gain2 = ST_PRESS_LPS331AP_FS_AVL_TEMP_GAIN,
 				},
 			},
 		},
 		.bdu = {
-			.addr = ST_PRESS_1_BDU_ADDR,
-			.mask = ST_PRESS_1_BDU_MASK,
+			.addr = ST_PRESS_LPS331AP_BDU_ADDR,
+			.mask = ST_PRESS_LPS331AP_BDU_MASK,
 		},
 		.drdy_irq = {
-			.addr = ST_PRESS_1_DRDY_IRQ_ADDR,
-			.mask_int1 = ST_PRESS_1_DRDY_IRQ_INT1_MASK,
-			.mask_int2 = ST_PRESS_1_DRDY_IRQ_INT2_MASK,
+			.addr = ST_PRESS_LPS331AP_DRDY_IRQ_ADDR,
+			.mask_int1 = ST_PRESS_LPS331AP_DRDY_IRQ_INT1_MASK,
+			.mask_int2 = ST_PRESS_LPS331AP_DRDY_IRQ_INT2_MASK,
 		},
-		.multi_read_bit = ST_PRESS_1_MULTIREAD_BIT,
+		.multi_read_bit = ST_PRESS_LPS331AP_MULTIREAD_BIT,
 		.bootime = 2,
 	},
 };
-- 
1.8.1.2

