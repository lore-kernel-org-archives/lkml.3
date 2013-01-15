Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3APAOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:14:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:42675 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403Ab3AOWcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ryo Tsutsui <Ryo.Tsutsui@wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 123/221] ASoC: arizona: Correct FLL source definitions
Date: Tue, 15 Jan 2013 10:50:50 -0800
Message-Id: <20130115185006.909821040@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit a8c02db029385fb4426e0396e108ab23cd08f384 upstream.

The FLL source constants were numbered as a simple enumeration but were
being used in the code as direct values to be written to the registers.
Renumber the constants to reflect the usage.

Reported-by: Ryo Tsutsui <Ryo.Tsutsui@wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/arizona.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/sound/soc/codecs/arizona.h
+++ b/sound/soc/codecs/arizona.h
@@ -32,15 +32,15 @@
 
 #define ARIZONA_FLL_SRC_MCLK1      0
 #define ARIZONA_FLL_SRC_MCLK2      1
-#define ARIZONA_FLL_SRC_SLIMCLK    2
-#define ARIZONA_FLL_SRC_FLL1       3
-#define ARIZONA_FLL_SRC_FLL2       4
-#define ARIZONA_FLL_SRC_AIF1BCLK   5
-#define ARIZONA_FLL_SRC_AIF2BCLK   6
-#define ARIZONA_FLL_SRC_AIF3BCLK   7
-#define ARIZONA_FLL_SRC_AIF1LRCLK  8
-#define ARIZONA_FLL_SRC_AIF2LRCLK  9
-#define ARIZONA_FLL_SRC_AIF3LRCLK 10
+#define ARIZONA_FLL_SRC_SLIMCLK    3
+#define ARIZONA_FLL_SRC_FLL1       4
+#define ARIZONA_FLL_SRC_FLL2       5
+#define ARIZONA_FLL_SRC_AIF1BCLK   8
+#define ARIZONA_FLL_SRC_AIF2BCLK   9
+#define ARIZONA_FLL_SRC_AIF3BCLK  10
+#define ARIZONA_FLL_SRC_AIF1LRCLK 12
+#define ARIZONA_FLL_SRC_AIF2LRCLK 13
+#define ARIZONA_FLL_SRC_AIF3LRCLK 14
 
 #define ARIZONA_MIXER_VOL_MASK             0x00FE
 #define ARIZONA_MIXER_VOL_SHIFT                 1


