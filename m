Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393Ab3EGD66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:58:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab3EGD6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:50 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wRUecpgMBT8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=B7JupE0Jc5cA:10 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=THCAyMpEAAAA:8 a=FNyBlpCuAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=WwgC8nHKvroA:10 a=FCIOWvmKq0cA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035845.404548217@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Magnus Myrstedt <magnus.p.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [027/126] crypto: ux500 - add missing comma
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0027-crypto-ux500-add-missing-comma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit d47cbd5bcee7c7a08fc0283dda465375fa1b1fda ]

Commit 4f31f5b19eb0418a847b989abc9ac22af1991fe2
"PM / crypto / ux500: Use struct dev_pm_ops for power management"
add a new line to the driver struct but missed to add a
trailing comma, causing build errors when crypto is
selected. This adds the missing comma.

This was not noticed until now because the crypto block
is not in the ux500 defconfig. A separate patch will
be submitted to fix this.

Cc: <stable@vger.kernel.org> # 3.8.x
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Magnus Myrstedt <magnus.p.persson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 1c307e1..b8b0497 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1750,7 +1750,7 @@ static struct platform_driver cryp_driver = {
 	.shutdown = ux500_cryp_shutdown,
 	.driver = {
 		.owner = THIS_MODULE,
-		.name  = "cryp1"
+		.name  = "cryp1",
 		.pm    = &ux500_cryp_pm,
 	}
 };
-- 
1.7.10.4


