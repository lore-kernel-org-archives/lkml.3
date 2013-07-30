Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3G3IKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:10:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43698 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3G3IKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:10:08 -0400
X-AuditID: cbfee68f-b7f436d000000f81-18-51f774dd6314
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Lee Jones'" <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 18/35] mfd: use dev_get_platdata()
Date: Tue, 30 Jul 2013 17:10:05 +0900
Message-id: <004301ce8cfc$32eaf7f0$98c0e7d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6M/Bh1YHGq5ZGLSXCuGEYsTfm8mw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zA917Jd8DDX7+kLa4vPASq8X9r0cZ
	LS7vmsNmcbqb1YHF4861PWwe804GevRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfGp03PWAuO
	XGCqWHD7KHMD44LZTF2MnBwSAiYSL3+vYYGwxSQu3FvP1sXIxSEksIxRYt+/+YwwRZuO/mCB
	SCxilPhxZCEThPOLUWLi/61sIFVsAmoSX74cZgexRQS0JLqPnQeLMwtkSLzdfRBsnbCAkcTT
	Xe/A4iwCqhJ3PzYzg9i8ApYS848cYYOwBSV+TL7HAtGrJbF+53EmCFteYvOat8wQFylI7Dj7
	mhFil57Em5dXoepFJPa9eMcIcpyEwDp2iSkXJ7BDLBOQ+Db5EFARB1BCVmLTAag5khIHV9xg
	mcAoNgvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoREWv8OxrsH
	rA8xJgOtn8gsJZqcD4zUvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwxieoTLVaYLPraNrc70cnHJYs5mzJv7WxJbLooOX+K2YnzUtn73R4On+H
	iKzf/iDVtZsb4vsfbHkh/Stwv42cuMiRmbf/3vx8x0i+KvZV+YNP5+R2z13SwL6H+7P89uTV
	065rvCn5cHR/n8XZyaWuyewHeC9lOffNm1X4RP/Na+7dIq859ExF45VYijMSDbWYi4oTAVHj
	qFXKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAd27Jd8DDbYt07S4vPASq8X9r0cZ
	LS7vmsNmcbqb1YHF4861PWwe804GevRtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2S
	d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QRiWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxqdNz1gLjlxgqlhw+yhzA+OC2UxdjJwcEgImEpuO/mCBsMUkLtxb
	z9bFyMUhJLCIUeLHkYVMEM4vRomJ/7eygVSxCahJfPlymB3EFhHQkug+dh4sziyQIfF290Gw
	qcICRhJPd70Di7MIqErc/djMDGLzClhKzD9yhA3CFpT4MfkeC0SvlsT6nceZIGx5ic1r3jJD
	XKQgsePsa0aIXXoSb15ehaoXkdj34h3jBEaBWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERzHz6R2MK5ssDjEKMDBqMTDu6HgW6AQa2JZcWXuIUYJDmYlEV6W
	G0Ah3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgemmLySeENjEzMjSyMzCyMTc3PShJXEeQ+0
	WgcKCaQnlqRmp6YWpBbBbGHi4JRqYGSP6te9tYrx7hK7ZwbLN74MZVUPrrtUljw5brVpsP0L
	v/Y9PoJCPDnuV11cJ92qkQsL5J3BrK+sHVkpMtct6f32zz2t38o0svyUXCIlHOVmqmvwtPim
	ifzKKW/K4W7iK9jeHJQVNy/hbkx6zt7p/3eWuPi5vPynEHvnVc7WA1qTM/7fONqpxFKckWio
	xVxUnAgAMC0d4CcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/88pm800.c       |    2 +-
 drivers/mfd/88pm805.c       |    2 +-
 drivers/mfd/88pm860x-core.c |    2 +-
 drivers/mfd/aat2870-core.c  |    2 +-
 drivers/mfd/ab3100-core.c   |    2 +-
 drivers/mfd/adp5520.c       |    2 +-
 drivers/mfd/as3711.c        |    2 +-
 drivers/mfd/asic3.c         |    2 +-
 drivers/mfd/da903x.c        |    2 +-
 drivers/mfd/da9052-core.c   |    2 +-
 drivers/mfd/da9055-core.c   |    2 +-
 drivers/mfd/dm355evm_msp.c  |    4 ++--
 drivers/mfd/ezx-pcap.c      |    6 +++---
 drivers/mfd/htc-egpio.c     |    2 +-
 drivers/mfd/htc-i2cpld.c    |   10 +++++-----
 drivers/mfd/htc-pasic3.c    |    2 +-
 drivers/mfd/intel_msic.c    |    4 ++--
 drivers/mfd/kempld-core.c   |   12 ++++++------
 drivers/mfd/lm3533-core.c   |    8 ++++----
 drivers/mfd/lp8788.c        |    2 +-
 drivers/mfd/max77686.c      |    2 +-
 drivers/mfd/max77693.c      |    2 +-
 drivers/mfd/max8925-i2c.c   |    2 +-
 drivers/mfd/max8997.c       |    2 +-
 drivers/mfd/max8998.c       |    2 +-
 drivers/mfd/mcp-sa11x0.c    |    2 +-
 drivers/mfd/menelaus.c      |    2 +-
 drivers/mfd/omap-usb-host.c |    4 ++--
 drivers/mfd/pcf50633-core.c |    2 +-
 drivers/mfd/pm8921-core.c   |    2 +-
 drivers/mfd/rc5t583.c       |    2 +-
 drivers/mfd/sec-core.c      |    2 +-
 drivers/mfd/si476x-i2c.c    |    2 +-
 drivers/mfd/sm501.c         |    6 +++---
 drivers/mfd/sta2x11-mfd.c   |    4 ++--
 drivers/mfd/t7l66xb.c       |    8 ++++----
 drivers/mfd/tc3589x.c       |    2 +-
 drivers/mfd/tc6387xb.c      |    6 +++---
 drivers/mfd/tc6393xb.c      |    8 ++++----
 drivers/mfd/ti-ssp.c        |    2 +-
 drivers/mfd/tps6105x.c      |    2 +-
 drivers/mfd/tps65010.c      |    4 ++--
 drivers/mfd/tps65090.c      |    2 +-
 drivers/mfd/tps6586x.c      |    2 +-
 drivers/mfd/tps65912-core.c |    2 +-
 drivers/mfd/tps80031.c      |    2 +-
 drivers/mfd/twl-core.c      |    2 +-
 drivers/mfd/twl4030-audio.c |    2 +-
 drivers/mfd/twl4030-madc.c  |    2 +-
 drivers/mfd/twl4030-power.c |    2 +-
 drivers/mfd/twl6040.c       |    2 +-
 drivers/mfd/ucb1400_core.c  |    2 +-
 drivers/mfd/ucb1x00-core.c  |    4 ++--
 drivers/mfd/wl1273-core.c   |    2 +-
 drivers/mfd/wm831x-core.c   |    2 +-
 drivers/mfd/wm831x-irq.c    |    2 +-
 drivers/mfd/wm8350-i2c.c    |    3 ++-
 drivers/mfd/wm8400-core.c   |    2 +-
 drivers/mfd/wm8994-irq.c    |    2 +-
 59 files changed, 90 insertions(+), 89 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 6c95483..cd9e174 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -541,7 +541,7 @@ static int pm800_probe(struct i2c_client *client,
 {
 	int ret = 0;
 	struct pm80x_chip *chip;
-	struct pm80x_platform_data *pdata = client->dev.platform_data;
+	struct pm80x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct pm80x_subchip *subchip;
 
 	ret = pm80x_init(client);
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 5216022..0686cdb 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -227,7 +227,7 @@ static int pm805_probe(struct i2c_client *client,
 {
 	int ret = 0;
 	struct pm80x_chip *chip;
-	struct pm80x_platform_data *pdata = client->dev.platform_data;
+	struct pm80x_platform_data *pdata = dev_get_platdata(&client->dev);
 
 	ret = pm80x_init(client);
 	if (ret) {
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index eeb481d..7ebe9ef 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1130,7 +1130,7 @@ static int pm860x_dt_init(struct device_node *np,
 static int pm860x_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
-	struct pm860x_platform_data *pdata = client->dev.platform_data;
+	struct pm860x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct device_node *node = client->dev.of_node;
 	struct pm860x_chip *chip;
 	int ret;
diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index d4f5945..6f68472 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -363,7 +363,7 @@ static inline void aat2870_uninit_debugfs(struct aat2870_data *aat2870)
 static int aat2870_i2c_probe(struct i2c_client *client,
 			     const struct i2c_device_id *id)
 {
-	struct aat2870_platform_data *pdata = client->dev.platform_data;
+	struct aat2870_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct aat2870_data *aat2870;
 	int i, j;
 	int ret = 0;
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index ddc669d..b348ae5 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -854,7 +854,7 @@ static int ab3100_probe(struct i2c_client *client,
 {
 	struct ab3100 *ab3100;
 	struct ab3100_platform_data *ab3100_plf_data =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	int err;
 	int i;
 
diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 28346ad..6250155 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -207,7 +207,7 @@ static int adp5520_remove_subdevs(struct adp5520_chip *chip)
 static int adp5520_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
-	struct adp5520_platform_data *pdata = client->dev.platform_data;
+	struct adp5520_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct platform_device *pdev;
 	struct adp5520_chip *chip;
 	int ret;
diff --git a/drivers/mfd/as3711.c b/drivers/mfd/as3711.c
index 01e4141..abd3ab7 100644
--- a/drivers/mfd/as3711.c
+++ b/drivers/mfd/as3711.c
@@ -129,7 +129,7 @@ static int as3711_i2c_probe(struct i2c_client *client,
 	int ret;
 
 	if (!client->dev.of_node) {
-		pdata = client->dev.platform_data;
+		pdata = dev_get_platdata(&client->dev);
 		if (!pdata)
 			dev_dbg(&client->dev, "Platform data not found\n");
 	} else {
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 9532f74..fa22154 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -952,7 +952,7 @@ static void asic3_mfd_remove(struct platform_device *pdev)
 /* Core */
 static int __init asic3_probe(struct platform_device *pdev)
 {
-	struct asic3_platform_data *pdata = pdev->dev.platform_data;
+	struct asic3_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct asic3 *asic;
 	struct resource *mem;
 	unsigned long clksel;
diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index f1a316e..e0a2e0e 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -494,7 +494,7 @@ failed:
 static int da903x_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
-	struct da903x_platform_data *pdata = client->dev.platform_data;
+	struct da903x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct da903x_chip *chip;
 	unsigned int tmp;
 	int ret;
diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index a3c9613..ea28a33 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(da9052_regmap_config);
 
 int da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
-	struct da9052_pdata *pdata = da9052->dev->platform_data;
+	struct da9052_pdata *pdata = dev_get_platdata(da9052->dev);
 	int ret;
 
 	mutex_init(&da9052->auxadc_lock);
diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index 49cb23d..e292d69 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -379,7 +379,7 @@ static struct regmap_irq_chip da9055_regmap_irq_chip = {
 
 int da9055_device_init(struct da9055 *da9055)
 {
-	struct da9055_pdata *pdata = da9055->dev->platform_data;
+	struct da9055_pdata *pdata = dev_get_platdata(da9055->dev);
 	int ret;
 
 	if (pdata && pdata->init != NULL)
diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
index 7710227..7a55c00 100644
--- a/drivers/mfd/dm355evm_msp.c
+++ b/drivers/mfd/dm355evm_msp.c
@@ -315,8 +315,8 @@ static int add_children(struct i2c_client *client)
 	}
 
 	/* MMC/SD inputs -- right after the last config input */
-	if (client->dev.platform_data) {
-		void (*mmcsd_setup)(unsigned) = client->dev.platform_data;
+	if (dev_get_platdata(&client->dev)) {
+		void (*mmcsd_setup)(unsigned) = dev_get_platdata(&client->dev);
 
 		mmcsd_setup(dm355evm_msp_gpio.base + 8 + 5);
 	}
diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 5502106..7245b0c 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -177,7 +177,7 @@ static void pcap_msr_work(struct work_struct *work)
 static void pcap_isr_work(struct work_struct *work)
 {
 	struct pcap_chip *pcap = container_of(work, struct pcap_chip, isr_work);
-	struct pcap_platform_data *pdata = pcap->spi->dev.platform_data;
+	struct pcap_platform_data *pdata = dev_get_platdata(&pcap->spi->dev);
 	u32 msr, isr, int_sel, service;
 	int irq;
 
@@ -394,7 +394,7 @@ static int pcap_add_subdev(struct pcap_chip *pcap,
 static int ezx_pcap_remove(struct spi_device *spi)
 {
 	struct pcap_chip *pcap = spi_get_drvdata(spi);
-	struct pcap_platform_data *pdata = spi->dev.platform_data;
+	struct pcap_platform_data *pdata = dev_get_platdata(&spi->dev);
 	int i, adc_irq;
 
 	/* remove all registered subdevs */
@@ -420,7 +420,7 @@ static int ezx_pcap_remove(struct spi_device *spi)
 
 static int ezx_pcap_probe(struct spi_device *spi)
 {
-	struct pcap_platform_data *pdata = spi->dev.platform_data;
+	struct pcap_platform_data *pdata = dev_get_platdata(&spi->dev);
 	struct pcap_chip *pcap;
 	int i, adc_irq;
 	int ret = -ENODEV;
diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index 26aca54..49f39fe 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -261,7 +261,7 @@ static void egpio_write_cache(struct egpio_info *ei)
 
 static int __init egpio_probe(struct platform_device *pdev)
 {
-	struct htc_egpio_platform_data *pdata = pdev->dev.platform_data;
+	struct htc_egpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct resource   *res;
 	struct egpio_info *ei;
 	struct gpio_chip  *chip;
diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index c9dfce6..d7b2a75 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -340,7 +340,7 @@ static int htcpld_setup_chip_irq(
 	int ret = 0;
 
 	/* Get the platform and driver data */
-	pdata = dev->platform_data;
+	pdata = dev_get_platdata(dev);
 	htcpld = platform_get_drvdata(pdev);
 	chip = &htcpld->chip[chip_index];
 	plat_chip_data = &pdata->chip[chip_index];
@@ -375,7 +375,7 @@ static int htcpld_register_chip_i2c(
 	struct i2c_board_info info;
 
 	/* Get the platform and driver data */
-	pdata = dev->platform_data;
+	pdata = dev_get_platdata(dev);
 	htcpld = platform_get_drvdata(pdev);
 	chip = &htcpld->chip[chip_index];
 	plat_chip_data = &pdata->chip[chip_index];
@@ -447,7 +447,7 @@ static int htcpld_register_chip_gpio(
 	int ret = 0;
 
 	/* Get the platform and driver data */
-	pdata = dev->platform_data;
+	pdata = dev_get_platdata(dev);
 	htcpld = platform_get_drvdata(pdev);
 	chip = &htcpld->chip[chip_index];
 	plat_chip_data = &pdata->chip[chip_index];
@@ -509,7 +509,7 @@ static int htcpld_setup_chips(struct platform_device *pdev)
 	int i;
 
 	/* Get the platform and driver data */
-	pdata = dev->platform_data;
+	pdata = dev_get_platdata(dev);
 	htcpld = platform_get_drvdata(pdev);
 
 	/* Setup each chip's output GPIOs */
@@ -574,7 +574,7 @@ static int htcpld_core_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENODEV;
 
-	pdata = dev->platform_data;
+	pdata = dev_get_platdata(dev);
 	if (!pdata) {
 		dev_warn(dev, "Platform data not found for htcpld core!\n");
 		return -ENXIO;
diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 0a5e85f..6bf92a5 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -126,7 +126,7 @@ static struct mfd_cell ds1wm_cell __initdata = {
 
 static int __init pasic3_probe(struct platform_device *pdev)
 {
-	struct pasic3_platform_data *pdata = pdev->dev.platform_data;
+	struct pasic3_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct device *dev = &pdev->dev;
 	struct pasic3_data *asic;
 	struct resource *r;
diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index 4f2462f..9203d47 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -310,7 +310,7 @@ EXPORT_SYMBOL_GPL(intel_msic_irq_read);
 static int intel_msic_init_devices(struct intel_msic *msic)
 {
 	struct platform_device *pdev = msic->pdev;
-	struct intel_msic_platform_data *pdata = pdev->dev.platform_data;
+	struct intel_msic_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	int ret, i;
 
 	if (pdata->gpio) {
@@ -372,7 +372,7 @@ static void intel_msic_remove_devices(struct intel_msic *msic)
 
 static int intel_msic_probe(struct platform_device *pdev)
 {
-	struct intel_msic_platform_data *pdata = pdev->dev.platform_data;
+	struct intel_msic_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct intel_msic *msic;
 	struct resource *res;
 	u8 id0, id1;
diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index 686a456..ab36e6e 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -258,7 +258,7 @@ EXPORT_SYMBOL_GPL(kempld_write32);
  */
 void kempld_get_mutex(struct kempld_device_data *pld)
 {
-	struct kempld_platform_data *pdata = pld->dev->platform_data;
+	struct kempld_platform_data *pdata = dev_get_platdata(pld->dev);
 
 	mutex_lock(&pld->lock);
 	pdata->get_hardware_mutex(pld);
@@ -271,7 +271,7 @@ EXPORT_SYMBOL_GPL(kempld_get_mutex);
  */
 void kempld_release_mutex(struct kempld_device_data *pld)
 {
-	struct kempld_platform_data *pdata = pld->dev->platform_data;
+	struct kempld_platform_data *pdata = dev_get_platdata(pld->dev);
 
 	pdata->release_hardware_mutex(pld);
 	mutex_unlock(&pld->lock);
@@ -288,7 +288,7 @@ EXPORT_SYMBOL_GPL(kempld_release_mutex);
  */
 static int kempld_get_info(struct kempld_device_data *pld)
 {
-	struct kempld_platform_data *pdata = pld->dev->platform_data;
+	struct kempld_platform_data *pdata = dev_get_platdata(pld->dev);
 
 	return pdata->get_info(pld);
 }
@@ -302,7 +302,7 @@ static int kempld_get_info(struct kempld_device_data *pld)
  */
 static int kempld_register_cells(struct kempld_device_data *pld)
 {
-	struct kempld_platform_data *pdata = pld->dev->platform_data;
+	struct kempld_platform_data *pdata = dev_get_platdata(pld->dev);
 
 	return pdata->register_cells(pld);
 }
@@ -357,7 +357,7 @@ static int kempld_detect_device(struct kempld_device_data *pld)
 
 static int kempld_probe(struct platform_device *pdev)
 {
-	struct kempld_platform_data *pdata = pdev->dev.platform_data;
+	struct kempld_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct device *dev = &pdev->dev;
 	struct kempld_device_data *pld;
 	struct resource *ioport;
@@ -394,7 +394,7 @@ static int kempld_probe(struct platform_device *pdev)
 static int kempld_remove(struct platform_device *pdev)
 {
 	struct kempld_device_data *pld = platform_get_drvdata(pdev);
-	struct kempld_platform_data *pdata = pld->dev->platform_data;
+	struct kempld_platform_data *pdata = dev_get_platdata(pld->dev);
 
 	mfd_remove_devices(&pdev->dev);
 	pdata->release_hardware_mutex(pld);
diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index 4b7e6da..8c29f7b 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -384,7 +384,7 @@ static struct attribute_group lm3533_attribute_group = {
 
 static int lm3533_device_als_init(struct lm3533 *lm3533)
 {
-	struct lm3533_platform_data *pdata = lm3533->dev->platform_data;
+	struct lm3533_platform_data *pdata = dev_get_platdata(lm3533->dev);
 	int ret;
 
 	if (!pdata->als)
@@ -407,7 +407,7 @@ static int lm3533_device_als_init(struct lm3533 *lm3533)
 
 static int lm3533_device_bl_init(struct lm3533 *lm3533)
 {
-	struct lm3533_platform_data *pdata = lm3533->dev->platform_data;
+	struct lm3533_platform_data *pdata = dev_get_platdata(lm3533->dev);
 	int i;
 	int ret;
 
@@ -436,7 +436,7 @@ static int lm3533_device_bl_init(struct lm3533 *lm3533)
 
 static int lm3533_device_led_init(struct lm3533 *lm3533)
 {
-	struct lm3533_platform_data *pdata = lm3533->dev->platform_data;
+	struct lm3533_platform_data *pdata = dev_get_platdata(lm3533->dev);
 	int i;
 	int ret;
 
@@ -481,7 +481,7 @@ static int lm3533_device_setup(struct lm3533 *lm3533,
 
 static int lm3533_device_init(struct lm3533 *lm3533)
 {
-	struct lm3533_platform_data *pdata = lm3533->dev->platform_data;
+	struct lm3533_platform_data *pdata = dev_get_platdata(lm3533->dev);
 	int ret;
 
 	dev_dbg(lm3533->dev, "%s\n", __func__);
diff --git a/drivers/mfd/lp8788.c b/drivers/mfd/lp8788.c
index c3d3c9b..0f12219 100644
--- a/drivers/mfd/lp8788.c
+++ b/drivers/mfd/lp8788.c
@@ -173,7 +173,7 @@ static const struct regmap_config lp8788_regmap_config = {
 static int lp8788_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp8788 *lp;
-	struct lp8788_platform_data *pdata = cl->dev.platform_data;
+	struct lp8788_platform_data *pdata = dev_get_platdata(&cl->dev);
 	int ret;
 
 	lp = devm_kzalloc(&cl->dev, sizeof(struct lp8788), GFP_KERNEL);
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index f27a218..522be67 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -77,7 +77,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
 	struct max77686_dev *max77686 = NULL;
-	struct max77686_platform_data *pdata = i2c->dev.platform_data;
+	struct max77686_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	unsigned int data;
 	int ret = 0;
 
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 9e60fed..c04723e 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -110,7 +110,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
 	struct max77693_dev *max77693;
-	struct max77693_platform_data *pdata = i2c->dev.platform_data;
+	struct max77693_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	u8 reg_data;
 	int ret = 0;
 
diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index 8042b32..de7fb80 100644
--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -151,7 +151,7 @@ static int max8925_dt_init(struct device_node *np, struct device *dev,
 static int max8925_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
-	struct max8925_platform_data *pdata = client->dev.platform_data;
+	struct max8925_platform_data *pdata = dev_get_platdata(&client->dev);
 	static struct max8925_chip *chip;
 	struct device_node *node = client->dev.of_node;
 
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 1471405..ae55dd4 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -188,7 +188,7 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct max8997_dev *max8997;
-	struct max8997_platform_data *pdata = i2c->dev.platform_data;
+	struct max8997_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	int ret = 0;
 
 	max8997 = kzalloc(sizeof(struct max8997_dev), GFP_KERNEL);
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 21af51a..45bffb8 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -184,7 +184,7 @@ static inline int max8998_i2c_get_driver_data(struct i2c_client *i2c,
 static int max8998_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
-	struct max8998_platform_data *pdata = i2c->dev.platform_data;
+	struct max8998_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct max8998_dev *max8998;
 	int ret = 0;
 
diff --git a/drivers/mfd/mcp-sa11x0.c b/drivers/mfd/mcp-sa11x0.c
index 13198d9..41c31b3 100644
--- a/drivers/mfd/mcp-sa11x0.c
+++ b/drivers/mfd/mcp-sa11x0.c
@@ -156,7 +156,7 @@ static struct mcp_ops mcp_sa11x0 = {
 
 static int mcp_sa11x0_probe(struct platform_device *dev)
 {
-	struct mcp_plat_data *data = dev->dev.platform_data;
+	struct mcp_plat_data *data = dev_get_platdata(&dev->dev);
 	struct resource *mem0, *mem1;
 	struct mcp_sa11x0 *m;
 	struct mcp *mcp;
diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 998ce8c..9b72a44 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1189,7 +1189,7 @@ static int menelaus_probe(struct i2c_client *client,
 	int			rev = 0, val;
 	int			err = 0;
 	struct menelaus_platform_data *menelaus_pdata =
-					client->dev.platform_data;
+					dev_get_platdata(&client->dev);
 
 	if (the_menelaus) {
 		dev_dbg(&client->dev, "only one %s for now\n",
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 759fae3..d2b8e71 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -232,7 +232,7 @@ err_end:
 static int omap_usbhs_alloc_children(struct platform_device *pdev)
 {
 	struct device				*dev = &pdev->dev;
-	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
+	struct usbhs_omap_platform_data		*pdata = dev_get_platdata(dev);
 	struct platform_device			*ehci;
 	struct platform_device			*ohci;
 	struct resource				*res;
@@ -571,7 +571,7 @@ static struct of_device_id usbhs_child_match_table[] = {
 static int usbhs_omap_probe(struct platform_device *pdev)
 {
 	struct device			*dev =  &pdev->dev;
-	struct usbhs_omap_platform_data	*pdata = dev->platform_data;
+	struct usbhs_omap_platform_data	*pdata = dev_get_platdata(dev);
 	struct usbhs_hcd_omap		*omap;
 	struct resource			*res;
 	int				ret = 0;
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index d115673..6841d68 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -195,7 +195,7 @@ static int pcf50633_probe(struct i2c_client *client,
 				const struct i2c_device_id *ids)
 {
 	struct pcf50633 *pcf;
-	struct pcf50633_platform_data *pdata = client->dev.platform_data;
+	struct pcf50633_platform_data *pdata = dev_get_platdata(&client->dev);
 	int i, ret;
 	int version, variant;
 
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index ecc137f..9be6840 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -106,7 +106,7 @@ static int pm8921_add_subdevices(const struct pm8921_platform_data
 
 static int pm8921_probe(struct platform_device *pdev)
 {
-	const struct pm8921_platform_data *pdata = pdev->dev.platform_data;
+	const struct pm8921_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct pm8921 *pmic;
 	int rc;
 	u8 val;
diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index 14bdacc..3463301 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -250,7 +250,7 @@ static int rc5t583_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
 	struct rc5t583 *rc5t583;
-	struct rc5t583_platform_data *pdata = i2c->dev.platform_data;
+	struct rc5t583_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	int ret;
 	bool irq_init_success = false;
 
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 7976768..6c81cd5 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -182,7 +182,7 @@ static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
 static int sec_pmic_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
-	struct sec_platform_data *pdata = i2c->dev.platform_data;
+	struct sec_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	const struct regmap_config *regmap;
 	struct sec_pmic_dev *sec_pmic;
 	int ret;
diff --git a/drivers/mfd/si476x-i2c.c b/drivers/mfd/si476x-i2c.c
index f5bc8e4..0e4a76d 100644
--- a/drivers/mfd/si476x-i2c.c
+++ b/drivers/mfd/si476x-i2c.c
@@ -718,7 +718,7 @@ static int si476x_core_probe(struct i2c_client *client,
 	atomic_set(&core->is_alive, 0);
 	core->power_state = SI476X_POWER_DOWN;
 
-	pdata = client->dev.platform_data;
+	pdata = dev_get_platdata(&client->dev);
 	if (pdata) {
 		memcpy(&core->power_up_parameters,
 		       &pdata->power_up_parameters,
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 9816c23..33f040c 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -840,7 +840,7 @@ static int sm501_register_uart(struct sm501_devdata *sm, int devices)
 	if (!pdev)
 		return -ENOMEM;
 
-	uart_data = pdev->dev.platform_data;
+	uart_data = dev_get_platdata(&pdev->dev);
 
 	if (devices & SM501_USE_UART0) {
 		sm501_setup_uart_data(sm, uart_data++, 0x30000);
@@ -1167,7 +1167,7 @@ static int sm501_register_gpio_i2c_instance(struct sm501_devdata *sm,
 	if (!pdev)
 		return -ENOMEM;
 
-	icd = pdev->dev.platform_data;
+	icd = dev_get_platdata(&pdev->dev);
 
 	/* We keep the pin_sda and pin_scl fields relative in case the
 	 * same platform data is passed to >1 SM501.
@@ -1403,7 +1403,7 @@ static int sm501_plat_probe(struct platform_device *dev)
 
 	sm->dev = &dev->dev;
 	sm->pdev_id = dev->id;
-	sm->platdata = dev->dev.platform_data;
+	sm->platdata = dev_get_platdata(&dev->dev);
 
 	ret = platform_get_irq(dev, 0);
 	if (ret < 0) {
diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index d70a3430..65c6fa6 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -133,7 +133,7 @@ int sta2x11_mfd_get_regs_data(struct platform_device *dev,
 			      void __iomem **regs,
 			      spinlock_t **lock)
 {
-	struct pci_dev *pdev = *(struct pci_dev **)(dev->dev.platform_data);
+	struct pci_dev *pdev = *(struct pci_dev **)dev_get_platdata(&dev->dev);
 	struct sta2x11_mfd *mfd;
 
 	if (!pdev)
@@ -312,7 +312,7 @@ static int sta2x11_mfd_platform_probe(struct platform_device *dev,
 	const char *name = sta2x11_mfd_names[index];
 	struct regmap_config *regmap_config = sta2x11_mfd_regmap_configs[index];
 
-	pdev = dev->dev.platform_data;
+	pdev = dev_get_platdata(&dev->dev);
 	mfd = sta2x11_mfd_find(*pdev);
 	if (!mfd)
 		return -ENODEV;
diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index a21bff2..9e04a74 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -281,7 +281,7 @@ static void t7l66xb_detach_irq(struct platform_device *dev)
 static int t7l66xb_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
-	struct t7l66xb_platform_data *pdata = dev->dev.platform_data;
+	struct t7l66xb_platform_data *pdata = dev_get_platdata(&dev->dev);
 
 	if (pdata && pdata->suspend)
 		pdata->suspend(dev);
@@ -293,7 +293,7 @@ static int t7l66xb_suspend(struct platform_device *dev, pm_message_t state)
 static int t7l66xb_resume(struct platform_device *dev)
 {
 	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
-	struct t7l66xb_platform_data *pdata = dev->dev.platform_data;
+	struct t7l66xb_platform_data *pdata = dev_get_platdata(&dev->dev);
 
 	clk_enable(t7l66xb->clk48m);
 	if (pdata && pdata->resume)
@@ -313,7 +313,7 @@ static int t7l66xb_resume(struct platform_device *dev)
 
 static int t7l66xb_probe(struct platform_device *dev)
 {
-	struct t7l66xb_platform_data *pdata = dev->dev.platform_data;
+	struct t7l66xb_platform_data *pdata = dev_get_platdata(&dev->dev);
 	struct t7l66xb *t7l66xb;
 	struct resource *iomem, *rscr;
 	int ret;
@@ -409,7 +409,7 @@ err_noirq:
 
 static int t7l66xb_remove(struct platform_device *dev)
 {
-	struct t7l66xb_platform_data *pdata = dev->dev.platform_data;
+	struct t7l66xb_platform_data *pdata = dev_get_platdata(&dev->dev);
 	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
 	int ret;
 
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 4cb92bb..70f4909f 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -325,7 +325,7 @@ static int tc3589x_of_probe(struct device_node *np,
 static int tc3589x_probe(struct i2c_client *i2c,
 				   const struct i2c_device_id *id)
 {
-	struct tc3589x_platform_data *pdata = i2c->dev.platform_data;
+	struct tc3589x_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct device_node *np = i2c->dev.of_node;
 	struct tc3589x *tc3589x;
 	int ret;
diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index 65c425a..acd0f3a 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -48,7 +48,7 @@ static struct resource tc6387xb_mmc_resources[] = {
 static int tc6387xb_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
-	struct tc6387xb_platform_data *pdata = dev->dev.platform_data;
+	struct tc6387xb_platform_data *pdata = dev_get_platdata(&dev->dev);
 
 	if (pdata && pdata->suspend)
 		pdata->suspend(dev);
@@ -60,7 +60,7 @@ static int tc6387xb_suspend(struct platform_device *dev, pm_message_t state)
 static int tc6387xb_resume(struct platform_device *dev)
 {
 	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
-	struct tc6387xb_platform_data *pdata = dev->dev.platform_data;
+	struct tc6387xb_platform_data *pdata = dev_get_platdata(&dev->dev);
 
 	clk_enable(tc6387xb->clk32k);
 	if (pdata && pdata->resume)
@@ -140,7 +140,7 @@ static struct mfd_cell tc6387xb_cells[] = {
 
 static int tc6387xb_probe(struct platform_device *dev)
 {
-	struct tc6387xb_platform_data *pdata = dev->dev.platform_data;
+	struct tc6387xb_platform_data *pdata = dev_get_platdata(&dev->dev);
 	struct resource *iomem, *rscr;
 	struct clk *clk32k;
 	struct tc6387xb *tc6387xb;
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index a563dfa..11c19e5 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -604,7 +604,7 @@ static void tc6393xb_detach_irq(struct platform_device *dev)
 
 static int tc6393xb_probe(struct platform_device *dev)
 {
-	struct tc6393xb_platform_data *tcpd = dev->dev.platform_data;
+	struct tc6393xb_platform_data *tcpd = dev_get_platdata(&dev->dev);
 	struct tc6393xb *tc6393xb;
 	struct resource *iomem, *rscr;
 	int ret, temp;
@@ -733,7 +733,7 @@ err_kzalloc:
 
 static int tc6393xb_remove(struct platform_device *dev)
 {
-	struct tc6393xb_platform_data *tcpd = dev->dev.platform_data;
+	struct tc6393xb_platform_data *tcpd = dev_get_platdata(&dev->dev);
 	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
 	int ret;
 
@@ -765,7 +765,7 @@ static int tc6393xb_remove(struct platform_device *dev)
 #ifdef CONFIG_PM
 static int tc6393xb_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct tc6393xb_platform_data *tcpd = dev->dev.platform_data;
+	struct tc6393xb_platform_data *tcpd = dev_get_platdata(&dev->dev);
 	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
 	int i, ret;
 
@@ -788,7 +788,7 @@ static int tc6393xb_suspend(struct platform_device *dev, pm_message_t state)
 
 static int tc6393xb_resume(struct platform_device *dev)
 {
-	struct tc6393xb_platform_data *tcpd = dev->dev.platform_data;
+	struct tc6393xb_platform_data *tcpd = dev_get_platdata(&dev->dev);
 	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
 	int ret;
 	int i;
diff --git a/drivers/mfd/ti-ssp.c b/drivers/mfd/ti-ssp.c
index 09a14ce..1c2b994 100644
--- a/drivers/mfd/ti-ssp.c
+++ b/drivers/mfd/ti-ssp.c
@@ -318,7 +318,7 @@ static irqreturn_t ti_ssp_interrupt(int irq, void *dev_data)
 static int ti_ssp_probe(struct platform_device *pdev)
 {
 	static struct ti_ssp *ssp;
-	const struct ti_ssp_data *pdata = pdev->dev.platform_data;
+	const struct ti_ssp_data *pdata = dev_get_platdata(&pdev->dev);
 	int error = 0, prediv = 0xff, id;
 	unsigned long sysclk;
 	struct device *dev = &pdev->dev;
diff --git a/drivers/mfd/tps6105x.c b/drivers/mfd/tps6105x.c
index 1d302f5..b5dfa6e 100644
--- a/drivers/mfd/tps6105x.c
+++ b/drivers/mfd/tps6105x.c
@@ -147,7 +147,7 @@ static int tps6105x_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, tps6105x);
 	tps6105x->client = client;
-	pdata = client->dev.platform_data;
+	pdata = dev_get_platdata(&client->dev);
 	tps6105x->pdata = pdata;
 	mutex_init(&tps6105x->lock);
 
diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index da2691f..4d67692 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -517,7 +517,7 @@ static struct tps65010 *the_tps;
 static int __exit tps65010_remove(struct i2c_client *client)
 {
 	struct tps65010		*tps = i2c_get_clientdata(client);
-	struct tps65010_board	*board = client->dev.platform_data;
+	struct tps65010_board	*board = dev_get_platdata(&client->dev);
 
 	if (board && board->teardown) {
 		int status = board->teardown(client, board->context);
@@ -539,7 +539,7 @@ static int tps65010_probe(struct i2c_client *client,
 {
 	struct tps65010		*tps;
 	int			status;
-	struct tps65010_board	*board = client->dev.platform_data;
+	struct tps65010_board	*board = dev_get_platdata(&client->dev);
 
 	if (the_tps) {
 		dev_dbg(&client->dev, "only one tps6501x chip allowed\n");
diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index fbd6ee6..e6f03a7 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -172,7 +172,7 @@ MODULE_DEVICE_TABLE(of, tps65090_of_match);
 static int tps65090_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
-	struct tps65090_platform_data *pdata = client->dev.platform_data;
+	struct tps65090_platform_data *pdata = dev_get_platdata(&client->dev);
 	int irq_base = 0;
 	struct tps65090 *tps65090;
 	int ret;
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 4b93ed4..f54fe4d 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -462,7 +462,7 @@ static void tps6586x_power_off(void)
 static int tps6586x_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
-	struct tps6586x_platform_data *pdata = client->dev.platform_data;
+	struct tps6586x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct tps6586x *tps6586x;
 	int ret;
 
diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index 479886a..925a044 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -123,7 +123,7 @@ EXPORT_SYMBOL_GPL(tps65912_reg_write);
 
 int tps65912_device_init(struct tps65912 *tps65912)
 {
-	struct tps65912_board *pmic_plat_data = tps65912->dev->platform_data;
+	struct tps65912_board *pmic_plat_data = dev_get_platdata(tps65912->dev);
 	struct tps65912_platform_data *init_data;
 	int ret, dcdc_avs, value;
 
diff --git a/drivers/mfd/tps80031.c b/drivers/mfd/tps80031.c
index c90a2c4..f15ee6d 100644
--- a/drivers/mfd/tps80031.c
+++ b/drivers/mfd/tps80031.c
@@ -418,7 +418,7 @@ static const struct regmap_config tps80031_regmap_configs[] = {
 static int tps80031_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
-	struct tps80031_platform_data *pdata = client->dev.platform_data;
+	struct tps80031_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct tps80031 *tps80031;
 	int ret;
 	uint8_t es_version;
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 7f150d9..29473c2 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1137,7 +1137,7 @@ static int twl_remove(struct i2c_client *client)
 static int
 twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	struct twl4030_platform_data	*pdata = client->dev.platform_data;
+	struct twl4030_platform_data	*pdata = dev_get_platdata(&client->dev);
 	struct device_node		*node = client->dev.of_node;
 	struct platform_device		*pdev;
 	struct regmap_config		*twl_regmap_config;
diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index a31fba9..07fe542 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -187,7 +187,7 @@ static bool twl4030_audio_has_vibra(struct twl4030_audio_data *pdata,
 static int twl4030_audio_probe(struct platform_device *pdev)
 {
 	struct twl4030_audio *audio;
-	struct twl4030_audio_data *pdata = pdev->dev.platform_data;
+	struct twl4030_audio_data *pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *node = pdev->dev.of_node;
 	struct mfd_cell *cell = NULL;
 	int ret, childs = 0;
diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 1ea54d4..4c583e4 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -701,7 +701,7 @@ static int twl4030_madc_set_power(struct twl4030_madc_data *madc, int on)
 static int twl4030_madc_probe(struct platform_device *pdev)
 {
 	struct twl4030_madc_data *madc;
-	struct twl4030_madc_platform_data *pdata = pdev->dev.platform_data;
+	struct twl4030_madc_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	int ret;
 	u8 regval;
 
diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index a5fd3c7..275ec57 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -555,7 +555,7 @@ static bool twl4030_power_use_poweroff(struct twl4030_power_data *pdata,
 
 int twl4030_power_probe(struct platform_device *pdev)
 {
-	struct twl4030_power_data *pdata = pdev->dev.platform_data;
+	struct twl4030_power_data *pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *node = pdev->dev.of_node;
 	int err = 0;
 	int err2 = 0;
diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 492ee2c..a77e7be 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -520,7 +520,7 @@ static struct regmap_irq_chip twl6040_irq_chip = {
 static int twl6040_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
-	struct twl6040_platform_data *pdata = client->dev.platform_data;
+	struct twl6040_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct device_node *node = client->dev.of_node;
 	struct twl6040 *twl6040;
 	struct mfd_cell *cell = NULL;
diff --git a/drivers/mfd/ucb1400_core.c b/drivers/mfd/ucb1400_core.c
index e9031fa..ebb20ed 100644
--- a/drivers/mfd/ucb1400_core.c
+++ b/drivers/mfd/ucb1400_core.c
@@ -52,7 +52,7 @@ static int ucb1400_core_probe(struct device *dev)
 	struct ucb1400_ts ucb_ts;
 	struct ucb1400_gpio ucb_gpio;
 	struct snd_ac97 *ac97;
-	struct ucb1400_pdata *pdata = dev->platform_data;
+	struct ucb1400_pdata *pdata = dev_get_platdata(dev);
 
 	memset(&ucb_ts, 0, sizeof(ucb_ts));
 	memset(&ucb_gpio, 0, sizeof(ucb_gpio));
diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index 70f02da..48ad48c 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -671,7 +671,7 @@ void ucb1x00_unregister_driver(struct ucb1x00_driver *drv)
 
 static int ucb1x00_suspend(struct device *dev)
 {
-	struct ucb1x00_plat_data *pdata = dev->platform_data;
+	struct ucb1x00_plat_data *pdata = dev_get_platdata(dev);
 	struct ucb1x00 *ucb = dev_get_drvdata(dev);
 	struct ucb1x00_dev *udev;
 
@@ -703,7 +703,7 @@ static int ucb1x00_suspend(struct device *dev)
 
 static int ucb1x00_resume(struct device *dev)
 {
-	struct ucb1x00_plat_data *pdata = dev->platform_data;
+	struct ucb1x00_plat_data *pdata = dev_get_platdata(dev);
 	struct ucb1x00 *ucb = dev_get_drvdata(dev);
 	struct ucb1x00_dev *udev;
 
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index edbe6c1..1288e99 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -185,7 +185,7 @@ static int wl1273_core_remove(struct i2c_client *client)
 static int wl1273_core_probe(struct i2c_client *client,
 				       const struct i2c_device_id *id)
 {
-	struct wl1273_fm_platform_data *pdata = client->dev.platform_data;
+	struct wl1273_fm_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct wl1273_core *core;
 	struct mfd_cell *cell;
 	int children = 0;
diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 521340a..5c459f4 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1618,7 +1618,7 @@ EXPORT_SYMBOL_GPL(wm831x_regmap_config);
  */
 int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 {
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	int rev, wm831x_num;
 	enum wm831x_parent parent;
 	int ret, i;
diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 804e56e..64e512e 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -571,7 +571,7 @@ static struct irq_domain_ops wm831x_irq_domain_ops = {
 
 int wm831x_irq_init(struct wm831x *wm831x, int irq)
 {
-	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_pdata *pdata = dev_get_platdata(wm831x->dev);
 	struct irq_domain *domain;
 	int i, ret, irq_base;
 
diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index 2e57101..f919def 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -27,6 +27,7 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct wm8350 *wm8350;
+	struct wm8350_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	int ret = 0;
 
 	wm8350 = devm_kzalloc(&i2c->dev, sizeof(struct wm8350), GFP_KERNEL);
@@ -44,7 +45,7 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, wm8350);
 	wm8350->dev = &i2c->dev;
 
-	return wm8350_device_init(wm8350, i2c->irq, i2c->dev.platform_data);
+	return wm8350_device_init(wm8350, i2c->irq, pdata);
 }
 
 static int wm8350_i2c_remove(struct i2c_client *i2c)
diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 639ca35..d66d256 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -178,7 +178,7 @@ static int wm8400_i2c_probe(struct i2c_client *i2c,
 	wm8400->dev = &i2c->dev;
 	i2c_set_clientdata(i2c, wm8400);
 
-	ret = wm8400_init(wm8400, i2c->dev.platform_data);
+	ret = wm8400_init(wm8400, dev_get_platdata(&i2c->dev));
 	if (ret != 0)
 		goto err;
 
diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index d3a184a..e74dedd 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -193,7 +193,7 @@ int wm8994_irq_init(struct wm8994 *wm8994)
 {
 	int ret;
 	unsigned long irqflags;
-	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
+	struct wm8994_pdata *pdata = dev_get_platdata(wm8994->dev);
 
 	if (!wm8994->irq) {
 		dev_warn(wm8994->dev,
-- 
1.7.10.4


