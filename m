Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124Ab3GCTLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:11:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964918Ab3GCTAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:24 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=jVmePw86-70A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=T9Jre_BfIZUA:10 a=gAnH3GRIAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=rPGc2HzQRbAA:10 a=8NEP1B8RWw4A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184104.476293383@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [107/141] iio: frequency: ad4350: Fix bug / typo in mask
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0107-iio-frequency-ad4350-Fix-bug-typo-in-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

[ Upstream commit 2eb3a81eef0510511a3211bb3da560f446a8c8de ]

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/iio/frequency/adf4350.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/frequency/adf4350.c b/drivers/iio/frequency/adf4350.c
index e35bb8f..3e2a01c 100644
--- a/drivers/iio/frequency/adf4350.c
+++ b/drivers/iio/frequency/adf4350.c
@@ -212,7 +212,7 @@ static int adf4350_set_freq(struct adf4350_state *st, unsigned long long freq)
 		(pdata->r2_user_settings & (ADF4350_REG2_PD_POLARITY_POS |
 		ADF4350_REG2_LDP_6ns | ADF4350_REG2_LDF_INT_N |
 		ADF4350_REG2_CHARGE_PUMP_CURR_uA(5000) |
-		ADF4350_REG2_MUXOUT(0x7) | ADF4350_REG2_NOISE_MODE(0x9)));
+		ADF4350_REG2_MUXOUT(0x7) | ADF4350_REG2_NOISE_MODE(0x3)));
 
 	st->regs[ADF4350_REG3] = pdata->r3_user_settings &
 				 (ADF4350_REG3_12BIT_CLKDIV(0xFFF) |
-- 
1.7.10.4


