Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab3A1ORy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:17:54 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42353 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3A1ORv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:17:51 -0500
Message-ID: <1359382666.6625.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: gpio-regulator: Staticize
 of_get_gpio_regulator_config()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 22:17:46 +0800
In-Reply-To: <1359382563.6625.1.camel@phoenix>
References: <1359382563.6625.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_gpio_regulator_config() is only used in gpio-regulator.c, make it static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/gpio-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index d819ba7..9d39eb4 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -132,7 +132,7 @@ static struct regulator_ops gpio_regulator_voltage_ops = {
 	.list_voltage = gpio_regulator_list_voltage,
 };
 
-struct gpio_regulator_config *
+static struct gpio_regulator_config *
 of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 {
 	struct gpio_regulator_config *config;
-- 
1.7.9.5



