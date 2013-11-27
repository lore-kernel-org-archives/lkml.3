Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3K0MyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:54:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47367 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab3K0MyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:54:06 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: wm5110: Give new AIF2 registers defaults and mark as readable
Date: Wed, 27 Nov 2013 12:51:17 +0000
Message-Id: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The registers associated with the new channels on AIF2 were accidentally
missing defaults and not marked as readable this patch fixes this.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

This patch depends on the patch:

"ASoC: wm5110: Add extra AIF2 channels"

Which is going through the ASoC tree at the moment, so
probably best to send this patch through the ASoC tree as
well. As such I have generated it against Mark's for-next
branch, let me know if it needs regenerating.

Thanks,
Charles

 drivers/mfd/wm5110-tables.c |   64 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index d433e28..338cfbe 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -885,6 +885,38 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x0000074D, 0x0080 },    /* R1869  - AIF2TX2MIX Input 3 Volume */
 	{ 0x0000074E, 0x0000 },    /* R1870  - AIF2TX2MIX Input 4 Source */
 	{ 0x0000074F, 0x0080 },    /* R1871  - AIF2TX2MIX Input 4 Volume */
+	{ 0x00000750, 0x0000 },    /* R1872  - AIF2TX3MIX Input 1 Source */
+	{ 0x00000751, 0x0080 },    /* R1873  - AIF2TX3MIX Input 1 Volume */
+	{ 0x00000752, 0x0000 },    /* R1874  - AIF2TX3MIX Input 2 Source */
+	{ 0x00000753, 0x0080 },    /* R1875  - AIF2TX3MIX Input 2 Volume */
+	{ 0x00000754, 0x0000 },    /* R1876  - AIF2TX3MIX Input 3 Source */
+	{ 0x00000755, 0x0080 },    /* R1877  - AIF2TX3MIX Input 3 Volume */
+	{ 0x00000756, 0x0000 },    /* R1878  - AIF2TX3MIX Input 4 Source */
+	{ 0x00000757, 0x0080 },    /* R1879  - AIF2TX3MIX Input 4 Volume */
+	{ 0x00000758, 0x0000 },    /* R1880  - AIF2TX4MIX Input 1 Source */
+	{ 0x00000759, 0x0080 },    /* R1881  - AIF2TX4MIX Input 1 Volume */
+	{ 0x0000075A, 0x0000 },    /* R1882  - AIF2TX4MIX Input 2 Source */
+	{ 0x0000075B, 0x0080 },    /* R1883  - AIF2TX4MIX Input 2 Volume */
+	{ 0x0000075C, 0x0000 },    /* R1884  - AIF2TX4MIX Input 3 Source */
+	{ 0x0000075D, 0x0080 },    /* R1885  - AIF2TX4MIX Input 3 Volume */
+	{ 0x0000075E, 0x0000 },    /* R1886  - AIF2TX4MIX Input 4 Source */
+	{ 0x0000075F, 0x0080 },    /* R1887  - AIF2TX4MIX Input 4 Volume */
+	{ 0x00000760, 0x0000 },    /* R1888  - AIF2TX5MIX Input 1 Source */
+	{ 0x00000761, 0x0080 },    /* R1889  - AIF2TX5MIX Input 1 Volume */
+	{ 0x00000762, 0x0000 },    /* R1890  - AIF2TX5MIX Input 2 Source */
+	{ 0x00000763, 0x0080 },    /* R1891  - AIF2TX5MIX Input 2 Volume */
+	{ 0x00000764, 0x0000 },    /* R1892  - AIF2TX5MIX Input 3 Source */
+	{ 0x00000765, 0x0080 },    /* R1893  - AIF2TX5MIX Input 3 Volume */
+	{ 0x00000766, 0x0000 },    /* R1894  - AIF2TX5MIX Input 4 Source */
+	{ 0x00000767, 0x0080 },    /* R1895  - AIF2TX5MIX Input 4 Volume */
+	{ 0x00000768, 0x0000 },    /* R1896  - AIF2TX6MIX Input 1 Source */
+	{ 0x00000769, 0x0080 },    /* R1897  - AIF2TX6MIX Input 1 Volume */
+	{ 0x0000076A, 0x0000 },    /* R1898  - AIF2TX6MIX Input 2 Source */
+	{ 0x0000076B, 0x0080 },    /* R1899  - AIF2TX6MIX Input 2 Volume */
+	{ 0x0000076C, 0x0000 },    /* R1900  - AIF2TX6MIX Input 3 Source */
+	{ 0x0000076D, 0x0080 },    /* R1901  - AIF2TX6MIX Input 3 Volume */
+	{ 0x0000076E, 0x0000 },    /* R1902  - AIF2TX6MIX Input 4 Source */
+	{ 0x0000076F, 0x0080 },    /* R1903  - AIF2TX6MIX Input 4 Volume */
 	{ 0x00000780, 0x0000 },    /* R1920  - AIF3TX1MIX Input 1 Source */
 	{ 0x00000781, 0x0080 },    /* R1921  - AIF3TX1MIX Input 1 Volume */
 	{ 0x00000782, 0x0000 },    /* R1922  - AIF3TX1MIX Input 2 Source */
@@ -1883,6 +1915,38 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_AIF2TX2MIX_INPUT_3_VOLUME:
 	case ARIZONA_AIF2TX2MIX_INPUT_4_SOURCE:
 	case ARIZONA_AIF2TX2MIX_INPUT_4_VOLUME:
+	case ARIZONA_AIF2TX3MIX_INPUT_1_SOURCE:
+	case ARIZONA_AIF2TX3MIX_INPUT_1_VOLUME:
+	case ARIZONA_AIF2TX3MIX_INPUT_2_SOURCE:
+	case ARIZONA_AIF2TX3MIX_INPUT_2_VOLUME:
+	case ARIZONA_AIF2TX3MIX_INPUT_3_SOURCE:
+	case ARIZONA_AIF2TX3MIX_INPUT_3_VOLUME:
+	case ARIZONA_AIF2TX3MIX_INPUT_4_SOURCE:
+	case ARIZONA_AIF2TX3MIX_INPUT_4_VOLUME:
+	case ARIZONA_AIF2TX4MIX_INPUT_1_SOURCE:
+	case ARIZONA_AIF2TX4MIX_INPUT_1_VOLUME:
+	case ARIZONA_AIF2TX4MIX_INPUT_2_SOURCE:
+	case ARIZONA_AIF2TX4MIX_INPUT_2_VOLUME:
+	case ARIZONA_AIF2TX4MIX_INPUT_3_SOURCE:
+	case ARIZONA_AIF2TX4MIX_INPUT_3_VOLUME:
+	case ARIZONA_AIF2TX4MIX_INPUT_4_SOURCE:
+	case ARIZONA_AIF2TX4MIX_INPUT_4_VOLUME:
+	case ARIZONA_AIF2TX5MIX_INPUT_1_SOURCE:
+	case ARIZONA_AIF2TX5MIX_INPUT_1_VOLUME:
+	case ARIZONA_AIF2TX5MIX_INPUT_2_SOURCE:
+	case ARIZONA_AIF2TX5MIX_INPUT_2_VOLUME:
+	case ARIZONA_AIF2TX5MIX_INPUT_3_SOURCE:
+	case ARIZONA_AIF2TX5MIX_INPUT_3_VOLUME:
+	case ARIZONA_AIF2TX5MIX_INPUT_4_SOURCE:
+	case ARIZONA_AIF2TX5MIX_INPUT_4_VOLUME:
+	case ARIZONA_AIF2TX6MIX_INPUT_1_SOURCE:
+	case ARIZONA_AIF2TX6MIX_INPUT_1_VOLUME:
+	case ARIZONA_AIF2TX6MIX_INPUT_2_SOURCE:
+	case ARIZONA_AIF2TX6MIX_INPUT_2_VOLUME:
+	case ARIZONA_AIF2TX6MIX_INPUT_3_SOURCE:
+	case ARIZONA_AIF2TX6MIX_INPUT_3_VOLUME:
+	case ARIZONA_AIF2TX6MIX_INPUT_4_SOURCE:
+	case ARIZONA_AIF2TX6MIX_INPUT_4_VOLUME:
 	case ARIZONA_AIF3TX1MIX_INPUT_1_SOURCE:
 	case ARIZONA_AIF3TX1MIX_INPUT_1_VOLUME:
 	case ARIZONA_AIF3TX1MIX_INPUT_2_SOURCE:
-- 
1.7.2.5

