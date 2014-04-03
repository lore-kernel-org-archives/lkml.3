Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaDCNo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:44:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49320 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaDCNow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:44:52 -0400
Message-ID: <1396532687.15484.3.camel@phoenix>
Subject: [PATCH] pinctrl: adi2: Statize adi_gpio_irq_domain_ops
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>
Date: Thu, 03 Apr 2014 21:44:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's only referenced in this file, make it static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-adi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index 0cc0eec..5c44feb 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -927,7 +927,7 @@ static int adi_gpio_irq_map(struct irq_domain *d, unsigned int irq,
 	return 0;
 }
 
-const struct irq_domain_ops adi_gpio_irq_domain_ops = {
+static const struct irq_domain_ops adi_gpio_irq_domain_ops = {
 	.map = adi_gpio_irq_map,
 	.xlate = irq_domain_xlate_onecell,
 };
-- 
1.8.3.2



