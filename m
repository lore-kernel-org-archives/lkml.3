Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3CONBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:01:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42205 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab3CONBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:01:39 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 01/50] staging: omap-thermal: use BIT() macro
Date: Fri, 15 Mar 2013 08:59:49 -0400
Message-ID: <1363352438-15935-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For code readability, this patch changes the bit definition
under omap-bandgap.h to use the BIT() macro.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.h |   96 +++++++++++++-------------
 1 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index 3e9072c..8d3ee2b 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -29,17 +29,17 @@
 
 /* TEMP_SENSOR OMAP4430 */
 #define OMAP4430_BGAP_TSHUT_SHIFT			11
-#define OMAP4430_BGAP_TSHUT_MASK			(1 << 11)
+#define OMAP4430_BGAP_TSHUT_MASK			BIT(11)
 
 /* TEMP_SENSOR OMAP4430 */
 #define OMAP4430_BGAP_TEMPSOFF_SHIFT			12
-#define OMAP4430_BGAP_TEMPSOFF_MASK			(1 << 12)
+#define OMAP4430_BGAP_TEMPSOFF_MASK			BIT(12)
 #define OMAP4430_SINGLE_MODE_SHIFT			10
-#define OMAP4430_SINGLE_MODE_MASK			(1 << 10)
+#define OMAP4430_SINGLE_MODE_MASK			BIT(10)
 #define OMAP4430_BGAP_TEMP_SENSOR_SOC_SHIFT		9
-#define OMAP4430_BGAP_TEMP_SENSOR_SOC_MASK		(1 << 9)
+#define OMAP4430_BGAP_TEMP_SENSOR_SOC_MASK		BIT(9)
 #define OMAP4430_BGAP_TEMP_SENSOR_EOCZ_SHIFT		8
-#define OMAP4430_BGAP_TEMP_SENSOR_EOCZ_MASK		(1 << 8)
+#define OMAP4430_BGAP_TEMP_SENSOR_EOCZ_MASK		BIT(8)
 #define OMAP4430_BGAP_TEMP_SENSOR_DTEMP_SHIFT		0
 #define OMAP4430_BGAP_TEMP_SENSOR_DTEMP_MASK		(0xff << 0)
 
@@ -53,21 +53,21 @@
 
 /* TEMP_SENSOR OMAP4460 */
 #define OMAP4460_BGAP_TEMPSOFF_SHIFT			13
-#define OMAP4460_BGAP_TEMPSOFF_MASK			(1 << 13)
+#define OMAP4460_BGAP_TEMPSOFF_MASK			BIT(13)
 #define OMAP4460_BGAP_TEMP_SENSOR_SOC_SHIFT		11
-#define OMAP4460_BGAP_TEMP_SENSOR_SOC_MASK		(1 << 11)
+#define OMAP4460_BGAP_TEMP_SENSOR_SOC_MASK		BIT(11)
 #define OMAP4460_BGAP_TEMP_SENSOR_EOCZ_SHIFT		10
-#define OMAP4460_BGAP_TEMP_SENSOR_EOCZ_MASK		(1 << 10)
+#define OMAP4460_BGAP_TEMP_SENSOR_EOCZ_MASK		BIT(10)
 #define OMAP4460_BGAP_TEMP_SENSOR_DTEMP_SHIFT		0
 #define OMAP4460_BGAP_TEMP_SENSOR_DTEMP_MASK		(0x3ff << 0)
 
 /* BANDGAP_CTRL */
 #define OMAP4460_SINGLE_MODE_SHIFT			31
-#define OMAP4460_SINGLE_MODE_MASK			(1 << 31)
+#define OMAP4460_SINGLE_MODE_MASK			BIT(31)
 #define OMAP4460_MASK_HOT_SHIFT				1
-#define OMAP4460_MASK_HOT_MASK				(1 << 1)
+#define OMAP4460_MASK_HOT_MASK				BIT(1)
 #define OMAP4460_MASK_COLD_SHIFT			0
-#define OMAP4460_MASK_COLD_MASK				(1 << 0)
+#define OMAP4460_MASK_COLD_MASK				BIT(0)
 
 /* BANDGAP_COUNTER */
 #define OMAP4460_COUNTER_SHIFT				0
@@ -87,57 +87,57 @@
 
 /* BANDGAP_STATUS */
 #define OMAP4460_CLEAN_STOP_SHIFT			3
-#define OMAP4460_CLEAN_STOP_MASK			(1 << 3)
+#define OMAP4460_CLEAN_STOP_MASK			BIT(3)
 #define OMAP4460_BGAP_ALERT_SHIFT			2
-#define OMAP4460_BGAP_ALERT_MASK			(1 << 2)
+#define OMAP4460_BGAP_ALERT_MASK			BIT(2)
 #define OMAP4460_HOT_FLAG_SHIFT				1
-#define OMAP4460_HOT_FLAG_MASK				(1 << 1)
+#define OMAP4460_HOT_FLAG_MASK				BIT(1)
 #define OMAP4460_COLD_FLAG_SHIFT			0
-#define OMAP4460_COLD_FLAG_MASK				(1 << 0)
+#define OMAP4460_COLD_FLAG_MASK				BIT(0)
 
 /* TEMP_SENSOR OMAP5430 */
 #define OMAP5430_BGAP_TEMP_SENSOR_SOC_SHIFT		12
-#define OMAP5430_BGAP_TEMP_SENSOR_SOC_MASK		(1 << 12)
+#define OMAP5430_BGAP_TEMP_SENSOR_SOC_MASK		BIT(12)
 #define OMAP5430_BGAP_TEMPSOFF_SHIFT			11
-#define OMAP5430_BGAP_TEMPSOFF_MASK			(1 << 11)
+#define OMAP5430_BGAP_TEMPSOFF_MASK			BIT(11)
 #define OMAP5430_BGAP_TEMP_SENSOR_EOCZ_SHIFT		10
-#define OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK		(1 << 10)
+#define OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK		BIT(10)
 #define OMAP5430_BGAP_TEMP_SENSOR_DTEMP_SHIFT		0
 #define OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK		(0x3ff << 0)
 
 /* BANDGAP_CTRL */
 #define OMAP5430_MASK_HOT_CORE_SHIFT			5
-#define OMAP5430_MASK_HOT_CORE_MASK			(1 << 5)
+#define OMAP5430_MASK_HOT_CORE_MASK			BIT(5)
 #define OMAP5430_MASK_COLD_CORE_SHIFT			4
-#define OMAP5430_MASK_COLD_CORE_MASK			(1 << 4)
+#define OMAP5430_MASK_COLD_CORE_MASK			BIT(4)
 #define OMAP5430_MASK_HOT_GPU_SHIFT			3
-#define OMAP5430_MASK_HOT_GPU_MASK			(1 << 3)
+#define OMAP5430_MASK_HOT_GPU_MASK			BIT(3)
 #define OMAP5430_MASK_COLD_GPU_SHIFT			2
-#define OMAP5430_MASK_COLD_GPU_MASK			(1 << 2)
+#define OMAP5430_MASK_COLD_GPU_MASK			BIT(2)
 #define OMAP5430_MASK_HOT_MPU_SHIFT			1
-#define OMAP5430_MASK_HOT_MPU_MASK			(1 << 1)
+#define OMAP5430_MASK_HOT_MPU_MASK			BIT(1)
 #define OMAP5430_MASK_COLD_MPU_SHIFT			0
-#define OMAP5430_MASK_COLD_MPU_MASK			(1 << 0)
+#define OMAP5430_MASK_COLD_MPU_MASK			BIT(0)
 #define OMAP5430_MASK_SIDLEMODE_SHIFT			30
 #define OMAP5430_MASK_SIDLEMODE_MASK			(0x3 << 30)
 #define OMAP5430_MASK_FREEZE_CORE_SHIFT			23
-#define OMAP5430_MASK_FREEZE_CORE_MASK			(1 << 23)
+#define OMAP5430_MASK_FREEZE_CORE_MASK			BIT(23)
 #define OMAP5430_MASK_FREEZE_GPU_SHIFT			22
-#define OMAP5430_MASK_FREEZE_GPU_MASK			(1 << 22)
+#define OMAP5430_MASK_FREEZE_GPU_MASK			BIT(22)
 #define OMAP5430_MASK_FREEZE_MPU_SHIFT			21
-#define OMAP5430_MASK_FREEZE_MPU_MASK			(1 << 21)
+#define OMAP5430_MASK_FREEZE_MPU_MASK			BIT(21)
 #define OMAP5430_MASK_CLEAR_CORE_SHIFT			20
-#define OMAP5430_MASK_CLEAR_CORE_MASK			(1 << 20)
+#define OMAP5430_MASK_CLEAR_CORE_MASK			BIT(20)
 #define OMAP5430_MASK_CLEAR_GPU_SHIFT			19
-#define OMAP5430_MASK_CLEAR_GPU_MASK			(1 << 19)
+#define OMAP5430_MASK_CLEAR_GPU_MASK			BIT(19)
 #define OMAP5430_MASK_CLEAR_MPU_SHIFT			18
-#define OMAP5430_MASK_CLEAR_MPU_MASK			(1 << 18)
+#define OMAP5430_MASK_CLEAR_MPU_MASK			BIT(18)
 #define OMAP5430_MASK_CLEAR_ACCUM_CORE_SHIFT		17
-#define OMAP5430_MASK_CLEAR_ACCUM_CORE_MASK		(1 << 17)
+#define OMAP5430_MASK_CLEAR_ACCUM_CORE_MASK		BIT(17)
 #define OMAP5430_MASK_CLEAR_ACCUM_GPU_SHIFT		16
-#define OMAP5430_MASK_CLEAR_ACCUM_GPU_MASK		(1 << 16)
+#define OMAP5430_MASK_CLEAR_ACCUM_GPU_MASK		BIT(16)
 #define OMAP5430_MASK_CLEAR_ACCUM_MPU_SHIFT		15
-#define OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK		(1 << 15)
+#define OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK		BIT(15)
 
 /* BANDGAP_COUNTER */
 #define OMAP5430_COUNTER_SHIFT				0
@@ -169,19 +169,19 @@
 
 /* BANDGAP_STATUS */
 #define OMAP5430_BGAP_ALERT_SHIFT			31
-#define OMAP5430_BGAP_ALERT_MASK			(1 << 31)
+#define OMAP5430_BGAP_ALERT_MASK			BIT(31)
 #define OMAP5430_HOT_CORE_FLAG_SHIFT			5
-#define OMAP5430_HOT_CORE_FLAG_MASK			(1 << 5)
+#define OMAP5430_HOT_CORE_FLAG_MASK			BIT(5)
 #define OMAP5430_COLD_CORE_FLAG_SHIFT			4
-#define OMAP5430_COLD_CORE_FLAG_MASK			(1 << 4)
+#define OMAP5430_COLD_CORE_FLAG_MASK			BIT(4)
 #define OMAP5430_HOT_GPU_FLAG_SHIFT			3
-#define OMAP5430_HOT_GPU_FLAG_MASK			(1 << 3)
+#define OMAP5430_HOT_GPU_FLAG_MASK			BIT(3)
 #define OMAP5430_COLD_GPU_FLAG_SHIFT			2
-#define OMAP5430_COLD_GPU_FLAG_MASK			(1 << 2)
+#define OMAP5430_COLD_GPU_FLAG_MASK			BIT(2)
 #define OMAP5430_HOT_MPU_FLAG_SHIFT			1
-#define OMAP5430_HOT_MPU_FLAG_MASK			(1 << 1)
+#define OMAP5430_HOT_MPU_FLAG_MASK			BIT(1)
 #define OMAP5430_COLD_MPU_FLAG_SHIFT			0
-#define OMAP5430_COLD_MPU_FLAG_MASK			(1 << 0)
+#define OMAP5430_COLD_MPU_FLAG_MASK			BIT(0)
 
 /* Offsets from the base of temperature sensor registers */
 
@@ -434,14 +434,14 @@ struct omap_temp_sensor {
  * @expose_sensor: callback to export sensor to thermal API
  */
 struct omap_bandgap_data {
-#define OMAP_BANDGAP_FEATURE_TSHUT		(1 << 0)
-#define OMAP_BANDGAP_FEATURE_TSHUT_CONFIG	(1 << 1)
-#define OMAP_BANDGAP_FEATURE_TALERT		(1 << 2)
-#define OMAP_BANDGAP_FEATURE_MODE_CONFIG	(1 << 3)
-#define OMAP_BANDGAP_FEATURE_COUNTER		(1 << 4)
-#define OMAP_BANDGAP_FEATURE_POWER_SWITCH	(1 << 5)
-#define OMAP_BANDGAP_FEATURE_CLK_CTRL		(1 << 6)
-#define OMAP_BANDGAP_FEATURE_FREEZE_BIT		(1 << 7)
+#define OMAP_BANDGAP_FEATURE_TSHUT		BIT(0)
+#define OMAP_BANDGAP_FEATURE_TSHUT_CONFIG	BIT(1)
+#define OMAP_BANDGAP_FEATURE_TALERT		BIT(2)
+#define OMAP_BANDGAP_FEATURE_MODE_CONFIG	BIT(3)
+#define OMAP_BANDGAP_FEATURE_COUNTER		BIT(4)
+#define OMAP_BANDGAP_FEATURE_POWER_SWITCH	BIT(5)
+#define OMAP_BANDGAP_FEATURE_CLK_CTRL		BIT(6)
+#define OMAP_BANDGAP_FEATURE_FREEZE_BIT		BIT(7)
 #define OMAP_BANDGAP_HAS(b, f)			\
 			((b)->conf->features & OMAP_BANDGAP_FEATURE_ ## f)
 	unsigned int			features;
-- 
1.7.7.1.488.ge8e1c

