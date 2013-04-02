Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab3DBLdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:33:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46539 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759941Ab3DBLc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:32:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 01/16] mfd: wm5102: Add registers for microphone detection level configuration
Date: Tue,  2 Apr 2013 12:32:33 +0100
Message-Id: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c           |    8 ++++++++
 include/linux/mfd/arizona/registers.h |    4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index a433f58..ca2aed6 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -331,6 +331,10 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x000002A3, 0x1102 },   /* R675   - Mic Detect 1 */ 
 	{ 0x000002A4, 0x009F },   /* R676   - Mic Detect 2 */ 
 	{ 0x000002A5, 0x0000 },   /* R677   - Mic Detect 3 */ 
+	{ 0x000002A6, 0x3737 },   /* R678   - Mic Detect Level 1 */
+	{ 0x000002A7, 0x372C },   /* R679   - Mic Detect Level 2 */
+	{ 0x000002A8, 0x1422 },   /* R680   - Mic Detect Level 3 */
+	{ 0x000002A9, 0x030A },   /* R681   - Mic Detect Level 4 */
 	{ 0x000002C3, 0x0000 },   /* R707   - Mic noise mix control 1 */ 
 	{ 0x000002CB, 0x0000 },   /* R715   - Isolation control */ 
 	{ 0x000002D3, 0x0000 },   /* R723   - Jack detect analogue */ 
@@ -1090,6 +1094,10 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_MIC_DETECT_1:
 	case ARIZONA_MIC_DETECT_2:
 	case ARIZONA_MIC_DETECT_3:
+	case ARIZONA_MIC_DETECT_LEVEL_1:
+	case ARIZONA_MIC_DETECT_LEVEL_2:
+	case ARIZONA_MIC_DETECT_LEVEL_3:
+	case ARIZONA_MIC_DETECT_LEVEL_4:
 	case ARIZONA_MIC_NOISE_MIX_CONTROL_1:
 	case ARIZONA_ISOLATION_CONTROL:
 	case ARIZONA_JACK_DETECT_ANALOGUE:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 3403551..f43aa7c 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -124,6 +124,10 @@
 #define ARIZONA_MIC_DETECT_1                     0x2A3
 #define ARIZONA_MIC_DETECT_2                     0x2A4
 #define ARIZONA_MIC_DETECT_3                     0x2A5
+#define ARIZONA_MIC_DETECT_LEVEL_1		 0x2A6
+#define ARIZONA_MIC_DETECT_LEVEL_2		 0x2A7
+#define ARIZONA_MIC_DETECT_LEVEL_3		 0x2A8
+#define ARIZONA_MIC_DETECT_LEVEL_4		 0x2A9
 #define ARIZONA_MIC_NOISE_MIX_CONTROL_1          0x2C3
 #define ARIZONA_ISOLATION_CONTROL                0x2CB
 #define ARIZONA_JACK_DETECT_ANALOGUE             0x2D3
-- 
1.7.10.4

