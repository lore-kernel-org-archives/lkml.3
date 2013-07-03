Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab3GCStn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:49:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20124 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab3GCSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:01 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=6VteFDRHFPsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RV1WYc6-kjwA:10 a=w1d2syhTAAAA:8 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=_inCW7atr90A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184050.409694593@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Schichan <nschichan@freebox.fr>,
        Brian Austin <brian.austin@cirrus.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [035/141] ASoC: cs42l52: fix default value for MASTERA_VOL.
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0035-ASoC-cs42l52-fix-default-value-for-MASTERA_VOL.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicolas Schichan <nschichan@freebox.fr>

[ Upstream commit 04d245b7899c020559402841d2f70ddd740a7704 ]

The default register value for MASTERA_VOL is 0x00, the same as
MASTERB_VOL.

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
Acked-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/codecs/cs42l52.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index d8cfcc7..d34aa42 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -87,7 +87,7 @@ static const struct reg_default cs42l52_reg_defaults[] = {
 	{ CS42L52_BEEP_VOL, 0x00 },	/* r1D Beep Volume off Time */
 	{ CS42L52_BEEP_TONE_CTL, 0x00 },	/* r1E Beep Tone Cfg. */
 	{ CS42L52_TONE_CTL, 0x00 },	/* r1F Tone Ctl */
-	{ CS42L52_MASTERA_VOL, 0x88 },	/* r20 Master A Volume */
+	{ CS42L52_MASTERA_VOL, 0x00 },	/* r20 Master A Volume */
 	{ CS42L52_MASTERB_VOL, 0x00 },	/* r21 Master B Volume */
 	{ CS42L52_HPA_VOL, 0x00 },	/* r22 Headphone A Volume */
 	{ CS42L52_HPB_VOL, 0x00 },	/* r23 Headphone B Volume */
-- 
1.7.10.4


