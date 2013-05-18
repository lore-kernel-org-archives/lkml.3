Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3ERCQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:16:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31662 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3ERCQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:43 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=nWP4jdIFTL8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=TRP7-PmHFTEA:10 a=uP1ucDPQAAAA:8 a=7KW0tsBSAAAA:8 a=jAfPOIUMAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=zaWHSuwd-w0A:10 a=qDg0F9w_zDsA:10 a=gE_ZUhsuebIA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021642.645221494@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 005/136 ] ARM: at91: Fix typo in restart code panic message
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0005-ARM-at91-Fix-typo-in-restart-code-panic-message.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

[ Upstream commit e7619459d47a673af3433208a42f583af920e9db ]

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> # 3.4+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-at91/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index bd0e88c..7255726 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -330,7 +330,7 @@ static void at91_dt_rstc(void)
 
 	of_id = of_match_node(rstc_ids, np);
 	if (!of_id)
-		panic("AT91: rtsc no restart function availlable\n");
+		panic("AT91: rtsc no restart function available\n");
 
 	arm_pm_restart = of_id->data;
 
-- 
1.7.10.4


