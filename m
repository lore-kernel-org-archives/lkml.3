Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab3CTMKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:10:37 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:42120 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960Ab3CTMKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:10:33 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: santosh.shilimkar@ti.com, khilman@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH 02/10] gpio: gpio-mvebu.c: fix checkpatch errors
Date: Wed, 20 Mar 2013 13:15:56 +0100
Message-Id: <1363781764-17330-3-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
References: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix :
 gpio/gpio-mvebu.c:120: ERROR: space required before the open parenthesis '('
 gpio/gpio-mvebu.c:136: ERROR: space required before the open parenthesis '('
 gpio/gpio-mvebu.c:154: ERROR: space required before the open parenthesis '('
 gpio/gpio-mvebu.c:404: ERROR: space required before the open parenthesis '('
 gpio/gpio-mvebu.c:476: ERROR: "(foo*)" should be "(foo *)"
 gpio/gpio-mvebu.c:480: ERROR: "(foo*)" should be "(foo *)"
 gpio/gpio-mvebu.c:484: ERROR: "(foo*)" should be "(foo *)"
 gpio/gpio-mvebu.c:512: ERROR: space prohibited after that '!' (ctx:BxW)
 gpio/gpio-mvebu.c:518: ERROR: space prohibited after that '!' (ctx:BxW)
 gpio/gpio-mvebu.c:518: ERROR: space required before the open brace '{'
 gpio/gpio-mvebu.c:563: ERROR: space prohibited after that '!' (ctx:BxW)
 gpio/gpio-mvebu.c:570: ERROR: trailing whitespace
 gpio/gpio-mvebu.c:577: ERROR: space required before the open parenthesis '('
 gpio/gpio-mvebu.c:635: ERROR: space prohibited after that '!' (ctx:BxW)

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/gpio/gpio-mvebu.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 61a6fde..ca6d4ac 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -117,7 +117,7 @@ static inline void __iomem *mvebu_gpioreg_edge_cause(struct mvebu_gpio_chip *mvc
 {
 	int cpu;
 
-	switch(mvchip->soc_variant) {
+	switch (mvchip->soc_variant) {
 	case MVEBU_GPIO_SOC_VARIANT_ORION:
 	case MVEBU_GPIO_SOC_VARIANT_MV78200:
 		return mvchip->membase + GPIO_EDGE_CAUSE_OFF;
@@ -133,7 +133,7 @@ static inline void __iomem *mvebu_gpioreg_edge_mask(struct mvebu_gpio_chip *mvch
 {
 	int cpu;
 
-	switch(mvchip->soc_variant) {
+	switch (mvchip->soc_variant) {
 	case MVEBU_GPIO_SOC_VARIANT_ORION:
 		return mvchip->membase + GPIO_EDGE_MASK_OFF;
 	case MVEBU_GPIO_SOC_VARIANT_MV78200:
@@ -151,7 +151,7 @@ static void __iomem *mvebu_gpioreg_level_mask(struct mvebu_gpio_chip *mvchip)
 {
 	int cpu;
 
-	switch(mvchip->soc_variant) {
+	switch (mvchip->soc_variant) {
 	case MVEBU_GPIO_SOC_VARIANT_ORION:
 		return mvchip->membase + GPIO_LEVEL_MASK_OFF;
 	case MVEBU_GPIO_SOC_VARIANT_MV78200:
@@ -401,7 +401,7 @@ static int mvebu_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	/*
 	 * Configure interrupt polarity.
 	 */
-	switch(type) {
+	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
 	case IRQ_TYPE_LEVEL_HIGH:
 		u = readl_relaxed(mvebu_gpioreg_in_pol(mvchip));
@@ -473,15 +473,15 @@ static void mvebu_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 static struct of_device_id mvebu_gpio_of_match[] = {
 	{
 		.compatible = "marvell,orion-gpio",
-		.data       = (void*) MVEBU_GPIO_SOC_VARIANT_ORION,
+		.data       = (void *) MVEBU_GPIO_SOC_VARIANT_ORION,
 	},
 	{
 		.compatible = "marvell,mv78200-gpio",
-		.data       = (void*) MVEBU_GPIO_SOC_VARIANT_MV78200,
+		.data       = (void *) MVEBU_GPIO_SOC_VARIANT_MV78200,
 	},
 	{
 		.compatible = "marvell,armadaxp-gpio",
-		.data       = (void*) MVEBU_GPIO_SOC_VARIANT_ARMADAXP,
+		.data       = (void *) MVEBU_GPIO_SOC_VARIANT_ARMADAXP,
 	},
 	{
 		/* sentinel */
@@ -509,13 +509,13 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 		soc_variant = MVEBU_GPIO_SOC_VARIANT_ORION;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (! res) {
+	if (!res) {
 		dev_err(&pdev->dev, "Cannot get memory resource\n");
 		return -ENODEV;
 	}
 
 	mvchip = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_gpio_chip), GFP_KERNEL);
-	if (! mvchip){
+	if (!mvchip) {
 		dev_err(&pdev->dev, "Cannot allocate memory\n");
 		return -ENOMEM;
 	}
@@ -560,21 +560,21 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	 * per-CPU registers */
 	if (soc_variant == MVEBU_GPIO_SOC_VARIANT_ARMADAXP) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		if (! res) {
+		if (!res) {
 			dev_err(&pdev->dev, "Cannot get memory resource\n");
 			return -ENODEV;
 		}
 
 		mvchip->percpu_membase = devm_ioremap_resource(&pdev->dev,
 							       res);
-		if (IS_ERR(mvchip->percpu_membase)) 
+		if (IS_ERR(mvchip->percpu_membase))
 			return PTR_ERR(mvchip->percpu_membase);
 	}
 
 	/*
 	 * Mask and clear GPIO interrupts.
 	 */
-	switch(soc_variant) {
+	switch (soc_variant) {
 	case MVEBU_GPIO_SOC_VARIANT_ORION:
 		writel_relaxed(0, mvchip->membase + GPIO_EDGE_CAUSE_OFF);
 		writel_relaxed(0, mvchip->membase + GPIO_EDGE_MASK_OFF);
@@ -632,7 +632,7 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 
 	gc = irq_alloc_generic_chip("mvebu_gpio_irq", 2, mvchip->irqbase,
 				    mvchip->membase, handle_level_irq);
-	if (! gc) {
+	if (!gc) {
 		dev_err(&pdev->dev, "Cannot allocate generic irq_chip\n");
 		return -ENOMEM;
 	}
-- 
1.7.10.4

