Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3CSO6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:58:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37743 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab3CSO6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:58:14 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCHv2 09/12] staging: ti-soc-thermal: fix several kernel-doc warnings and error
Date: Tue, 19 Mar 2013 10:54:25 -0400
Message-ID: <1363704868-11843-10-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the documentation to remove
all warnings and errors reported by scripts/kernel-doc.
Most are missing arguments due to wrong format.

Cc: Nishanth Menon <nm@ti.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/ti-soc-thermal/ti-bandgap.c |   56 +++++++++++++-------------
 drivers/staging/ti-soc-thermal/ti-bandgap.h |    8 ++--
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index 7d67f72..a9d6d2a 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -340,6 +340,7 @@ exit:
 /**
  * ti_bandgap_unmask_interrupts() - unmasks the events of thot & tcold
  * @bgp: struct ti_bandgap pointer
+ * @id: bandgap sensor id
  * @t_hot: hot temperature value to trigger alert signal
  * @t_cold: cold temperature value to trigger alert signal
  *
@@ -570,9 +571,9 @@ exit:
 
 /**
  * ti_bandgap_read_thot() - reads sensor current thot
- * @bgp - pointer to bandgap instance
- * @id - sensor id
- * @thot - resulting current thot value
+ * @bgp: pointer to bandgap instance
+ * @id: sensor id
+ * @thot: resulting current thot value
  *
  * returns 0 on success or the proper error code
  */
@@ -583,9 +584,9 @@ int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot)
 
 /**
  * ti_bandgap_write_thot() - sets sensor current thot
- * @bgp - pointer to bandgap instance
- * @id - sensor id
- * @val - desired thot value
+ * @bgp: pointer to bandgap instance
+ * @id: sensor id
+ * @val: desired thot value
  *
  * returns 0 on success or the proper error code
  */
@@ -596,9 +597,9 @@ int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val)
 
 /**
  * ti_bandgap_read_tcold() - reads sensor current tcold
- * @bgp - pointer to bandgap instance
- * @id - sensor id
- * @tcold - resulting current tcold value
+ * @bgp: pointer to bandgap instance
+ * @id: sensor id
+ * @tcold: resulting current tcold value
  *
  * returns 0 on success or the proper error code
  */
@@ -609,9 +610,9 @@ int ti_bandgap_read_tcold(struct ti_bandgap *bgp, int id, int *tcold)
 
 /**
  * ti_bandgap_write_tcold() - sets the sensor tcold
- * @bgp - pointer to bandgap instance
- * @id - sensor id
- * @val - desired tcold value
+ * @bgp: pointer to bandgap instance
+ * @id: sensor id
+ * @val: desired tcold value
  *
  * returns 0 on success or the proper error code
  */
@@ -622,9 +623,9 @@ int ti_bandgap_write_tcold(struct ti_bandgap *bgp, int id, int val)
 
 /**
  * ti_bandgap_read_update_interval() - read the sensor update interval
- * @bgp - pointer to bandgap instance
- * @id - sensor id
- * @interval - resulting update interval in miliseconds
+ * @bgp: pointer to bandgap instance
+ * @id: sensor id
+ * @interval: resulting update interval in miliseconds
  *
  * returns 0 on success or the proper error code
  */
@@ -654,9 +655,9 @@ int ti_bandgap_read_update_interval(struct ti_bandgap *bgp, int id,
 
 /**
  * ti_bandgap_write_update_interval() - set the update interval
- * @bgp - pointer to bandgap instance
- * @id - sensor id
- * @interval - desired update interval in miliseconds
+ * @bgp: pointer to bandgap instance
+ * @id: sensor id
+ * @interval: desired update interval in miliseconds
  *
  * returns 0 on success or the proper error code
  */
@@ -680,9 +681,9 @@ int ti_bandgap_write_update_interval(struct ti_bandgap *bgp,
 
 /**
  * ti_bandgap_read_temperature() - report current temperature
- * @bgp - pointer to bandgap instance
- * @id - sensor id
- * @temperature - resulting temperature
+ * @bgp: pointer to bandgap instance
+ * @id: sensor id
+ * @temperature: resulting temperature
  *
  * returns 0 on success or the proper error code
  */
@@ -712,9 +713,9 @@ int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
 /**
  * ti_bandgap_set_sensor_data() - helper function to store thermal
  * framework related data.
- * @bgp - pointer to bandgap instance
- * @id - sensor id
- * @data - thermal framework related data to be stored
+ * @bgp: pointer to bandgap instance
+ * @id: sensor id
+ * @data: thermal framework related data to be stored
  *
  * returns 0 on success or the proper error code
  */
@@ -732,8 +733,8 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
 /**
  * ti_bandgap_get_sensor_data() - helper function to get thermal
  * framework related data.
- * @bgp - pointer to bandgap instance
- * @id - sensor id
+ * @bgp: pointer to bandgap instance
+ * @id: sensor id
  *
  * returns data stored by set function with sensor id on success or NULL
  */
@@ -875,16 +876,15 @@ static int ti_bandgap_talert_init(struct ti_bandgap *bgp,
 	return 0;
 }
 
+static const struct of_device_id of_ti_bandgap_match[];
 /**
  * ti_bandgap_build() - parse DT and setup a struct ti_bandgap
- * @bgp: pointer to struct ti_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Used to read the device tree properties accordingly to the bandgap
  * matching version. Based on bandgap version and its capabilities it
  * will build a struct ti_bandgap out of the required DT entries.
  */
-static const struct of_device_id of_ti_bandgap_match[];
 static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.h b/drivers/staging/ti-soc-thermal/ti-bandgap.h
index 394e8dd..04c6ec2 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.h
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.h
@@ -225,7 +225,7 @@ struct temp_sensor_regval {
  * @regval: temperature sensor register values
  * @fclock: pointer to functional clock of temperature sensor
  * @div_clk: pointer to divider clock of temperature sensor fclk
- * @bg_mutex: mutex for ti_bandgap structure
+ * @lock: spinlock for ti_bandgap structure
  * @irq: MPU IRQ number for thermal alert
  * @tshut_gpio: GPIO where Tshut signal is routed
  * @clk_rate: Holds current clock rate
@@ -253,7 +253,7 @@ struct ti_bandgap {
  * @registers: pointer to the list of register offsets and bitfields
  * @domain: the name of the domain where the sensor is located
  * @slope: sensor gradient slope info for hotspot extrapolation equation
- * @const: sensor gradient const info for hotspot extrapolation equation
+ * @constant: sensor gradient const info for hotspot extrapolation equation
  * @slope_pcb: sensor gradient slope info for hotspot extrapolation equation
  *             with no external influence
  * @constant_pcb: sensor gradient const info for hotspot extrapolation equation
@@ -281,7 +281,7 @@ struct ti_temp_sensor {
 };
 
 /**
- * DOC: omap bandgap feature types
+ * DOC: ti bandgap feature types
  *
  * TI_BANDGAP_FEATURE_TSHUT - used when the thermal shutdown signal output
  *      of a bandgap device instance is routed to the processor. This means
@@ -325,7 +325,7 @@ struct ti_temp_sensor {
 			((b)->conf->features & TI_BANDGAP_FEATURE_ ## f)
 
 /**
- * struct ti_bandgap_data - omap bandgap data configuration structure
+ * struct ti_bandgap_data - ti bandgap data configuration structure
  * @features: a bitwise flag set to describe the device features
  * @conv_table: Pointer to ADC to temperature conversion table
  * @adc_start_val: ADC conversion table starting value
-- 
1.7.7.1.488.ge8e1c

