Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3LPVZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:25:38 -0500
Received: from 4.mo1.mail-out.ovh.net ([46.105.76.26]:54703 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751093Ab3LPVZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:25:37 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH] clk: at91: fix pmc_clk_ids data type attriubte
Date: Mon, 16 Dec 2013 22:25:27 +0100
Message-Id: <1387229127-7605-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 8068198732589922454
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix pmc_clk_ids data type attribute (__initdata -> __initconst).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/clk/at91/pmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 7b9db60..4c03eda 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -228,7 +228,7 @@ out_free_pmc:
 	return NULL;
 }
 
-static const struct of_device_id pmc_clk_ids[] __initdata = {
+static const struct of_device_id pmc_clk_ids[] __initconst = {
 	/* Main clock */
 	{
 		.compatible = "atmel,at91rm9200-clk-main",
-- 
1.7.9.5

