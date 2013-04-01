Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3DAR2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:28:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47087 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756929Ab3DAR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 15/15] mfd: wm5102: Update defaults to match patch
Date: Mon,  1 Apr 2013 18:28:12 +0100
Message-Id: <1364837292-30191-15-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Registers which have defaults and are updated by the patch file should
have their defaults updated to match the value set by the patch file,
otherwise incorrect values will be read from the cache.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 44cb7be..bf02862 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -382,7 +382,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000400, 0x0000 },   /* R1024  - Output Enables 1 */ 
 	{ 0x00000408, 0x0000 },   /* R1032  - Output Rate 1 */ 
 	{ 0x00000409, 0x0022 },   /* R1033  - Output Volume Ramp */ 
-	{ 0x00000410, 0x4080 },   /* R1040  - Output Path Config 1L */
+	{ 0x00000410, 0x6080 },   /* R1040  - Output Path Config 1L */
 	{ 0x00000411, 0x0180 },   /* R1041  - DAC Digital Volume 1L */ 
 	{ 0x00000412, 0x0081 },   /* R1042  - DAC Volume Limit 1L */
 	{ 0x00000413, 0x0001 },   /* R1043  - Noise Gate Select 1L */ 
@@ -390,7 +390,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000415, 0x0180 },   /* R1045  - DAC Digital Volume 1R */ 
 	{ 0x00000416, 0x0081 },   /* R1046  - DAC Volume Limit 1R */
 	{ 0x00000417, 0x0002 },   /* R1047  - Noise Gate Select 1R */ 
-	{ 0x00000418, 0x4080 },   /* R1048  - Output Path Config 2L */
+	{ 0x00000418, 0xA080 },   /* R1048  - Output Path Config 2L */
 	{ 0x00000419, 0x0180 },   /* R1049  - DAC Digital Volume 2L */ 
 	{ 0x0000041A, 0x0081 },   /* R1050  - DAC Volume Limit 2L */
 	{ 0x0000041B, 0x0004 },   /* R1051  - Noise Gate Select 2L */ 
@@ -398,11 +398,11 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x0000041D, 0x0180 },   /* R1053  - DAC Digital Volume 2R */ 
 	{ 0x0000041E, 0x0081 },   /* R1054  - DAC Volume Limit 2R */
 	{ 0x0000041F, 0x0008 },   /* R1055  - Noise Gate Select 2R */ 
-	{ 0x00000420, 0x4080 },   /* R1056  - Output Path Config 3L */
+	{ 0x00000420, 0xA080 },   /* R1056  - Output Path Config 3L */
 	{ 0x00000421, 0x0180 },   /* R1057  - DAC Digital Volume 3L */ 
 	{ 0x00000422, 0x0081 },   /* R1058  - DAC Volume Limit 3L */
 	{ 0x00000423, 0x0010 },   /* R1059  - Noise Gate Select 3L */ 
-	{ 0x00000428, 0xC000 },   /* R1064  - Output Path Config 4L */
+	{ 0x00000428, 0xE000 },   /* R1064  - Output Path Config 4L */
 	{ 0x00000429, 0x0180 },   /* R1065  - DAC Digital Volume 4L */ 
 	{ 0x0000042A, 0x0081 },   /* R1066  - Out Volume 4L */
 	{ 0x0000042B, 0x0040 },   /* R1067  - Noise Gate Select 4L */ 
@@ -417,7 +417,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000436, 0x0081 },   /* R1078  - DAC Volume Limit 5R */
 	{ 0x00000437, 0x0200 },   /* R1079  - Noise Gate Select 5R */
 	{ 0x00000450, 0x0000 },   /* R1104  - DAC AEC Control 1 */ 
-	{ 0x00000458, 0x0001 },   /* R1112  - Noise Gate Control */ 
+	{ 0x00000458, 0x000B },   /* R1112  - Noise Gate Control */ 
 	{ 0x00000490, 0x0069 },   /* R1168  - PDM SPK1 CTRL 1 */ 
 	{ 0x00000491, 0x0000 },   /* R1169  - PDM SPK1 CTRL 2 */ 
 	{ 0x00000500, 0x000C },   /* R1280  - AIF1 BCLK Ctrl */ 
-- 
1.7.10.4

