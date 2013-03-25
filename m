Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab3CYJ7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:59:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56082 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3CYJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:59:40 -0400
X-AuditID: cbfee68e-b7f946d000001e37-35-5150200addd9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] pinctrl: plgpio: add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Mon, 25 Mar 2013 18:59:38 +0900
Message-id: <003901ce293f$76639800$632ac800$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4pP3ZG1HYF/xTUQGOH688xjotmCA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zfV1uhYBAgxP3GC0uL7zEajHlz3Im
	i8u75rA5MHvcubaHzaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgyDs39yVjwlafi/MJuxgbG
	b1xdjJwcEgImEptunWWHsMUkLtxbz9bFyMUhJLCMUeJa82R2mKJLP7YxQSSmM0psn9bCBpIQ
	EvjFKDFzFQ+IzSagJvHly2GwBhEBPYk3X1uAbA4OZgEXiaPTREDCwgLBEhM61oGVsAioStzf
	uIoRxOYVsJWYsfg0G4QtKPFj8j0WEJtZQEti87YmVghbXmLzmrfMICMlBNQlHv3VBTFBNh34
	KAdRISKx78U7RpArJQRWsUv8bjkOtUpA4tvkQywQrbISmw4wQ3wlKXFwxQ2WCYxis5AsnoVk
	8Swki2chWbGAkWUVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRkg09e1gvHnA+hBjMtD6icxS
	osn5wGjMK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwen
	VANj1r73qavvOzpe/dvzQ72xL9+8QzTGyq1dha/n3XQrXnf7yN9qJypcdn/0e+9x+6LGnfpL
	Ux1XLJgvrZ8xbfIfpnnb91dbHj4mb1hzeGu7c81q17g+56lP8p3mnM/6WS1WW1Ko82TX1PyX
	pxc7rNOr6ONwZG/JW1ceuD04bL/h+uJ3kdMqmCYrsRRnJBpqMRcVJwIAVm9zZbwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xoC6XQkCgwbqHVhaXF15itZjyZzmT
	xeVdc9gcmD3uXNvD5tG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGYfm/mQs+MpTcX5hN2MD4zeuLkZODgkBE4lLP7YxQdhiEhfurWfrYuTiEBKYziix
	fVoLG0hCSOAXo8TMVTwgNpuAmsSXL4fZQWwRAT2JN19bgGwODmYBF4mj00RAwsICwRITOtaB
	lbAIqErc37iKEcTmFbCVmLH4NBuELSjxY/I9FhCbWUBLYvO2JlYIW15i85q3zCAjJQTUJR79
	1QUxQTYd+CgHUSEise/FO8YJjAKzkAyahWTQLCSDZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjOFafSe1gXNlgcYhRgINRiYdXoMY/UIg1say4MvcQowQHs5IIr5ZQQKAQb0pi
	ZVVqUX58UWlOavEhxmSgPycyS4km5wPTSF5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNIT
	S1KzU1MLUotgtjBxcEo1MJb1ett6LRZclCFRr/1Ad/3RW38WOHPtVb5if+n7ljvXL1msjPNW
	3SydscJy+TPFhZETLC+9lnlm2agx7c03h6OqayQdkquSWRji89nfnjXJ6fla6bOasfcQz2vF
	x/JvREWOxj2LXLb89qbElbN8T5dJlu9O2LpikdTEK4oqWVkNAQuORu5u9lBiKc5INNRiLipO
	BAC96bsHGQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
build warning when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
the CONFIG_PM_SLEEP is enabled.

drivers/pinctrl/spear/pinctrl-plgpio.c:645:12: warning: 'plgpio_suspend' defined but not used [-Wunused-function]
drivers/pinctrl/spear/pinctrl-plgpio.c:684:12: warning: 'plgpio_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pinctrl/spear/pinctrl-plgpio.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index 295b349..05e07d7 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -75,7 +75,7 @@ struct plgpio {
 	int			(*o2p)(int offset);	/* offset_to_pin */
 	u32			p2o_regs;
 	struct plgpio_regs	regs;
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	struct plgpio_regs	*csave_regs;
 #endif
 };
@@ -554,7 +554,7 @@ static int plgpio_probe(struct platform_device *pdev)
 	if (IS_ERR(plgpio->clk))
 		dev_warn(&pdev->dev, "clk_get() failed, work without it\n");
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	plgpio->csave_regs = devm_kzalloc(&pdev->dev,
 			sizeof(*plgpio->csave_regs) *
 			DIV_ROUND_UP(plgpio->chip.ngpio, MAX_GPIO_PER_REG),
@@ -641,7 +641,7 @@ unprepare_clk:
 	return ret;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int plgpio_suspend(struct device *dev)
 {
 	struct plgpio *plgpio = dev_get_drvdata(dev);
-- 
1.7.2.5


