Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3GWLeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:34:01 -0400
Received: from gloria.sntech.de ([95.129.55.99]:49567 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3GWLeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:34:00 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: rockchip: include correct clk header
Date: Tue, 23 Jul 2013 13:34:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307231334.21272.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct header to include for clock handling is clk.h .
clk-provider.h should not be used in simple clock consumers.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
After mixing them up to often this time, I'll hopefully remember this in
the future :-) .

 drivers/pinctrl/pinctrl-rockchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 1eb5a2e..dc90c02 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -36,7 +36,7 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf-generic.h>
 #include <linux/irqchip/chained_irq.h>
-#include <linux/clk-provider.h>
+#include <linux/clk.h>
 #include <dt-bindings/pinctrl/rockchip.h>
 
 #include "core.h"
-- 
1.7.10.4
