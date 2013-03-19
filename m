Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3CSTWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:22:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43130 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205Ab3CSTWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:22:20 -0400
Date: Tue, 19 Mar 2013 14:22:12 -0500
From: Nishanth Menon <nm@ti.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCHv2 09/12] staging: ti-soc-thermal: fix several kernel-doc
 warnings and error
Message-ID: <20130319192212.GA5610@kahuna>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
 <1363704868-11843-10-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363704868-11843-10-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:54-20130319, Eduardo Valentin wrote:
> This patch updates the documentation to remove
> all warnings and errors reported by scripts/kernel-doc.
> Most are missing arguments due to wrong format.
> 
> Cc: Nishanth Menon <nm@ti.com>
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/staging/ti-soc-thermal/ti-bandgap.c |   56 +++++++++++++-------------
>  drivers/staging/ti-soc-thermal/ti-bandgap.h |    8 ++--
>  2 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
> index 7d67f72..a9d6d2a 100644
> --- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
> @@ -340,6 +340,7 @@ exit:
>  /**
>   * ti_bandgap_unmask_interrupts() - unmasks the events of thot & tcold
>   * @bgp: struct ti_bandgap pointer
> + * @id: bandgap sensor id
>   * @t_hot: hot temperature value to trigger alert signal
>   * @t_cold: cold temperature value to trigger alert signal
>   *
> @@ -570,9 +571,9 @@ exit:
>  
>  /**
>   * ti_bandgap_read_thot() - reads sensor current thot
> - * @bgp - pointer to bandgap instance
> - * @id - sensor id
> - * @thot - resulting current thot value
> + * @bgp: pointer to bandgap instance
> + * @id: sensor id
> + * @thot: resulting current thot value
>   *
>   * returns 0 on success or the proper error code
>   */
> @@ -583,9 +584,9 @@ int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot)
>  
>  /**
>   * ti_bandgap_write_thot() - sets sensor current thot
> - * @bgp - pointer to bandgap instance
> - * @id - sensor id
> - * @val - desired thot value
> + * @bgp: pointer to bandgap instance
> + * @id: sensor id
> + * @val: desired thot value
>   *
>   * returns 0 on success or the proper error code
>   */
> @@ -596,9 +597,9 @@ int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val)
>  
>  /**
>   * ti_bandgap_read_tcold() - reads sensor current tcold
> - * @bgp - pointer to bandgap instance
> - * @id - sensor id
> - * @tcold - resulting current tcold value
> + * @bgp: pointer to bandgap instance
> + * @id: sensor id
> + * @tcold: resulting current tcold value
>   *
>   * returns 0 on success or the proper error code
>   */
> @@ -609,9 +610,9 @@ int ti_bandgap_read_tcold(struct ti_bandgap *bgp, int id, int *tcold)
>  
>  /**
>   * ti_bandgap_write_tcold() - sets the sensor tcold
> - * @bgp - pointer to bandgap instance
> - * @id - sensor id
> - * @val - desired tcold value
> + * @bgp: pointer to bandgap instance
> + * @id: sensor id
> + * @val: desired tcold value
>   *
>   * returns 0 on success or the proper error code
>   */
> @@ -622,9 +623,9 @@ int ti_bandgap_write_tcold(struct ti_bandgap *bgp, int id, int val)
>  
>  /**
>   * ti_bandgap_read_update_interval() - read the sensor update interval
> - * @bgp - pointer to bandgap instance
> - * @id - sensor id
> - * @interval - resulting update interval in miliseconds
> + * @bgp: pointer to bandgap instance
> + * @id: sensor id
> + * @interval: resulting update interval in miliseconds
>   *
>   * returns 0 on success or the proper error code
>   */
> @@ -654,9 +655,9 @@ int ti_bandgap_read_update_interval(struct ti_bandgap *bgp, int id,
>  
>  /**
>   * ti_bandgap_write_update_interval() - set the update interval
> - * @bgp - pointer to bandgap instance
> - * @id - sensor id
> - * @interval - desired update interval in miliseconds
> + * @bgp: pointer to bandgap instance
> + * @id: sensor id
> + * @interval: desired update interval in miliseconds
>   *
>   * returns 0 on success or the proper error code
>   */
> @@ -680,9 +681,9 @@ int ti_bandgap_write_update_interval(struct ti_bandgap *bgp,
>  
>  /**
>   * ti_bandgap_read_temperature() - report current temperature
> - * @bgp - pointer to bandgap instance
> - * @id - sensor id
> - * @temperature - resulting temperature
> + * @bgp: pointer to bandgap instance
> + * @id: sensor id
> + * @temperature: resulting temperature
>   *
>   * returns 0 on success or the proper error code
>   */
> @@ -712,9 +713,9 @@ int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
>  /**
>   * ti_bandgap_set_sensor_data() - helper function to store thermal
>   * framework related data.
> - * @bgp - pointer to bandgap instance
> - * @id - sensor id
> - * @data - thermal framework related data to be stored
> + * @bgp: pointer to bandgap instance
> + * @id: sensor id
> + * @data: thermal framework related data to be stored
>   *
>   * returns 0 on success or the proper error code
>   */
> @@ -732,8 +733,8 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
>  /**
>   * ti_bandgap_get_sensor_data() - helper function to get thermal
>   * framework related data.
> - * @bgp - pointer to bandgap instance
> - * @id - sensor id
> + * @bgp: pointer to bandgap instance
> + * @id: sensor id
>   *
>   * returns data stored by set function with sensor id on success or NULL
>   */
> @@ -875,16 +876,15 @@ static int ti_bandgap_talert_init(struct ti_bandgap *bgp,
>  	return 0;
>  }
>  
> +static const struct of_device_id of_ti_bandgap_match[];
>  /**
>   * ti_bandgap_build() - parse DT and setup a struct ti_bandgap
> - * @bgp: pointer to struct ti_bandgap
>   * @pdev: pointer to device struct platform_device
>   *
>   * Used to read the device tree properties accordingly to the bandgap
>   * matching version. Based on bandgap version and its capabilities it
>   * will build a struct ti_bandgap out of the required DT entries.
>   */
> -static const struct of_device_id of_ti_bandgap_match[];
>  static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
>  {
>  	struct device_node *node = pdev->dev.of_node;
> diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.h b/drivers/staging/ti-soc-thermal/ti-bandgap.h
> index 394e8dd..04c6ec2 100644
> --- a/drivers/staging/ti-soc-thermal/ti-bandgap.h
> +++ b/drivers/staging/ti-soc-thermal/ti-bandgap.h
> @@ -225,7 +225,7 @@ struct temp_sensor_regval {
>   * @regval: temperature sensor register values
>   * @fclock: pointer to functional clock of temperature sensor
>   * @div_clk: pointer to divider clock of temperature sensor fclk
> - * @bg_mutex: mutex for ti_bandgap structure
> + * @lock: spinlock for ti_bandgap structure
>   * @irq: MPU IRQ number for thermal alert
>   * @tshut_gpio: GPIO where Tshut signal is routed
>   * @clk_rate: Holds current clock rate
> @@ -253,7 +253,7 @@ struct ti_bandgap {
>   * @registers: pointer to the list of register offsets and bitfields
>   * @domain: the name of the domain where the sensor is located
>   * @slope: sensor gradient slope info for hotspot extrapolation equation
> - * @const: sensor gradient const info for hotspot extrapolation equation
> + * @constant: sensor gradient const info for hotspot extrapolation equation
>   * @slope_pcb: sensor gradient slope info for hotspot extrapolation equation
>   *             with no external influence
>   * @constant_pcb: sensor gradient const info for hotspot extrapolation equation
> @@ -281,7 +281,7 @@ struct ti_temp_sensor {
>  };
>  
>  /**
> - * DOC: omap bandgap feature types
> + * DOC: ti bandgap feature types
>   *
>   * TI_BANDGAP_FEATURE_TSHUT - used when the thermal shutdown signal output
>   *      of a bandgap device instance is routed to the processor. This means
> @@ -325,7 +325,7 @@ struct ti_temp_sensor {
>  			((b)->conf->features & TI_BANDGAP_FEATURE_ ## f)
>  
>  /**
> - * struct ti_bandgap_data - omap bandgap data configuration structure
> + * struct ti_bandgap_data - ti bandgap data configuration structure
>   * @features: a bitwise flag set to describe the device features
>   * @conv_table: Pointer to ADC to temperature conversion table
>   * @adc_start_val: ADC conversion table starting value
You may still want to fix warnings generated by:
./scripts/kernel-doc -v drivers/staging/ti-soc-thermal/ti-bandgap.c>/dev/null
For example - the following changes are required for proper error return
documentation (following diff is just an hint):

diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index d479e50..0adae05 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -50,7 +50,7 @@
  * @reg: desired register (offset) to be read
  *
  * Helper function to read bandgap registers. It uses the io remapped area.
- * Returns the register value.
+ * Return: the register value.
  */
 static u32 ti_bandgap_readl(struct ti_bandgap *bgp, u32 reg)
 {
@@ -97,6 +97,8 @@ do {								\
  *
  * Used to power on/off a bandgap device instance. Only used on those
  * that features tempsoff bit.
+ *
+ * Return: 0
  */
 static int ti_bandgap_power(struct ti_bandgap *bgp, bool on)
 {
@@ -122,6 +124,8 @@ exit:
  * This function is desired because, depending on bandgap device version,
  * it might be needed to freeze the bandgap state machine, before fetching
  * the register value.
+ *
+ * Return: temperature in ...
  */
 static u32 ti_bandgap_read_temp(struct ti_bandgap *bgp, int id)
 {
@@ -162,6 +166,8 @@ static u32 ti_bandgap_read_temp(struct ti_bandgap *bgp, int id)
  * conditions and acts accordingly. In case there are events pending,
  * it will reset the event mask to wait for the opposite event (next event).
  * Every time there is a new event, it will be reported to thermal layer.
+ *
+ * Return: IRQ_HANDLED
  */
 static irqreturn_t ti_bandgap_talert_irq_handler(int irq, void *data)
 {
@@ -222,6 +228,8 @@ static irqreturn_t ti_bandgap_talert_irq_handler(int irq, void *data)
  * This is the Tshut handler. Use it only if bandgap device features
  * HAS(TSHUT). If any sensor fires the Tshut signal, we simply shutdown
  * the system.
+ *
+ * Return: IRQ_HANDLED
  */
 static irqreturn_t ti_bandgap_tshut_irq_handler(int irq, void *data)
 {
@@ -244,6 +252,8 @@ static irqreturn_t ti_bandgap_tshut_irq_handler(int irq, void *data)
  * Simple conversion from ADC representation to mCelsius. In case the ADC value
  * is out of the ADC conv table range, it returns -ERANGE, 0 on success.
  * The conversion table is indexed by the ADC values.
+ *
+ * Return: 0 if converstion was successful, else -ERANGE if out of range
  */
 static
 int ti_bandgap_adc_to_mcelsius(struct ti_bandgap *bgp, int adc_val, int *t)
@@ -272,6 +282,8 @@ exit:
  * Simple conversion from mCelsius to ADC values. In case the temp value
  * is out of the ADC conv table range, it returns -ERANGE, 0 on success.
  * The conversion table is indexed by the ADC values.
+ *
+ * Return: 0 if converstion was successful, else -ERANGE if out of range
  */
 static
 int ti_bandgap_mcelsius_to_adc(struct ti_bandgap *bgp, long temp, int *adc)
@@ -311,7 +323,8 @@ exit:
  * @sum: address where to write the resulting temperature (in ADC scale)
  *
  * Adds an hysteresis value (in mCelsius) to a ADC temperature value.
- * Returns 0 on success, -ERANGE otherwise.
+ *
+ * Return: 0 on success, -ERANGE otherwise.
  */
 static
 int ti_bandgap_add_hyst(struct ti_bandgap *bgp, int adc_val, int hyst_val,
@@ -384,6 +397,8 @@ static void ti_bandgap_unmask_interrupts(struct ti_bandgap *bgp, int id,
  * It checks the resulting t_hot and t_cold values, based on the new passed @val
  * and configures the thresholds so that t_hot is always greater than t_cold.
  * Call this function only if bandgap features HAS(TALERT).
+ *
+ * Return: 0 if no error, else corresponding error
  */
 static int ti_bandgap_update_alert_threshold(struct ti_bandgap *bgp, int id,
 					     int val, bool hot)
@@ -442,6 +457,8 @@ exit:
  *
  * Checks if the bandgap pointer is valid and if the sensor id is also
  * applicable.
+ *
+ * Return: 0 if no errors, -EINVAL for bad parameter or -ERANGE if out of range
  */
 static inline int ti_bandgap_validate(struct ti_bandgap *bgp, int id)
 {
@@ -475,6 +492,8 @@ exit:
  * This function can be used to update t_hot or t_cold, depending on @hot value.
  * Validates the mCelsius range and update the requested threshold.
  * Call this function only if bandgap features HAS(TALERT).
+ *
+ * Return: 0 if no error, else corresponding error value.
  */
 static int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
 				       bool hot)
@@ -529,6 +548,8 @@ exit:
  * It will fetch the required thresholds (hot and cold) for TALERT signal.
  * This function can be used to read t_hot or t_cold, depending on @hot value.
  * Call this function only if bandgap features HAS(TALERT).
+ *
+ * Return: 0 if no error, if it has no TALERT support, returns -ENOTSUPP....
  */
 static int _ti_bandgap_read_threshold(struct ti_bandgap *bgp, int id,
 				      int *val, bool hot)
@@ -575,7 +596,7 @@ exit:
  * @id: sensor id
  * @thot: resulting current thot value
  *
- * returns 0 on success or the proper error code
+ * Return: 0 on success or the proper error code
  */
 int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot)
 {
@@ -588,7 +609,7 @@ int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot)
  * @id: sensor id
  * @val: desired thot value
  *
- * returns 0 on success or the proper error code
+ * Return: 0 on success or the proper error code
  */
 int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val)
 {
@@ -601,7 +622,7 @@ int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val)
  * @id: sensor id
  * @tcold: resulting current tcold value
  *
- * returns 0 on success or the proper error code
+ * Return: 0 on success or the proper error code
  */
 int ti_bandgap_read_tcold(struct ti_bandgap *bgp, int id, int *tcold)
 {
@@ -614,7 +635,7 @@ int ti_bandgap_read_tcold(struct ti_bandgap *bgp, int id, int *tcold)
  * @id: sensor id
  * @val: desired tcold value
  *
- * returns 0 on success or the proper error code
+ * Return: 0 on success or the proper error code
  */
 int ti_bandgap_write_tcold(struct ti_bandgap *bgp, int id, int val)
 {
@@ -627,7 +648,7 @@ int ti_bandgap_write_tcold(struct ti_bandgap *bgp, int id, int val)
  * @id: sensor id
  * @interval: resulting update interval in miliseconds
  *
- * returns 0 on success or the proper error code
+ * Return: 0 on success or the proper error code
  */
 int ti_bandgap_read_update_interval(struct ti_bandgap *bgp, int id,
 				    int *interval)
@@ -659,7 +680,7 @@ int ti_bandgap_read_update_interval(struct ti_bandgap *bgp, int id,
  * @id: sensor id
  * @interval: desired update interval in miliseconds
  *
- * returns 0 on success or the proper error code
+ * Return: 0 on success or the proper error code
  */
 int ti_bandgap_write_update_interval(struct ti_bandgap *bgp,
 				     int id, u32 interval)
@@ -685,7 +706,7 @@ int ti_bandgap_write_update_interval(struct ti_bandgap *bgp,
  * @id: sensor id
  * @temperature: resulting temperature
  *
- * returns 0 on success or the proper error code
+ * Return: 0 on success or the proper error code
  */
 int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
 				int *temperature)
@@ -717,7 +738,7 @@ int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
  * @id: sensor id
  * @data: thermal framework related data to be stored
  *
- * returns 0 on success or the proper error code
+ * Return: 0 on success or the proper error code
  */
 int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
 {
@@ -736,7 +757,7 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
  * @bgp: pointer to bandgap instance
  * @id: sensor id
  *
- * returns data stored by set function with sensor id on success or NULL
+ * Return: data stored by set function with sensor id on success or NULL
  */
 void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id)
 {
@@ -756,6 +777,8 @@ void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id)
  *
  * Used to initialize the conversion state machine and set it to a valid
  * state. Called during device initialization and context restore events.
+ *
+ * Return: 0
  */
 static int
 ti_bandgap_force_single_read(struct ti_bandgap *bgp, int id)
@@ -789,6 +812,8 @@ ti_bandgap_force_single_read(struct ti_bandgap *bgp, int id)
  * be used for junction temperature monitoring, it is desirable that the
  * sensors are operational all the time, so that alerts are generated
  * properly.
+ *
+ * Return: 0
  */
 static int ti_bandgap_set_continuous_mode(struct ti_bandgap *bgp)
 {
@@ -814,6 +839,8 @@ static int ti_bandgap_set_continuous_mode(struct ti_bandgap *bgp)
  * to specify which GPIO line is used. TSHUT IRQ is fired anytime
  * one of the bandgap sensors violates the TSHUT high/hot threshold.
  * And in that case, the system must go off.
+ *
+ * Return: 0 if no error, else error status
  */
 static int ti_bandgap_tshut_init(struct ti_bandgap *bgp,
 				 struct platform_device *pdev)
@@ -853,6 +880,8 @@ static int ti_bandgap_tshut_init(struct ti_bandgap *bgp,
  * TALERT is a normal IRQ and it is fired any time thresholds (hot or cold)
  * are violated. In these situation, the driver must reprogram the thresholds,
  * accordingly to specified policy.
+ *
+ * Return: 0 if no error, else return corresponding error.
  */
 static int ti_bandgap_talert_init(struct ti_bandgap *bgp,
 				  struct platform_device *pdev)
@@ -884,6 +913,9 @@ static const struct of_device_id of_ti_bandgap_match[];
  * Used to read the device tree properties accordingly to the bandgap
  * matching version. Based on bandgap version and its capabilities it
  * will build a struct ti_bandgap out of the required DT entries.
+ *
+ * Return: valid bandgap structure if successful, else returns ERR_PTR
+ * return value must be verified with IS_ERR.
  */
 static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 {
-- 
Regards,
Nishanth Menon
