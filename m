Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3AXD25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:28:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3AXD2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 16/74] ASoC: wm2200: Remove DSP B and left justified AIF modes
Date: Thu, 24 Jan 2013 01:26:28 -0200
Message-Id: <1358998046-613-17-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 0cc411b934c4317b363d1af993549f391852b980 upstream.

These are not supported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/codecs/wm2200.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index 201fc58..86b84a1 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -1380,15 +1380,9 @@ static int wm2200_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	case SND_SOC_DAIFMT_DSP_A:
 		fmt_val = 0;
 		break;
-	case SND_SOC_DAIFMT_DSP_B:
-		fmt_val = 1;
-		break;
 	case SND_SOC_DAIFMT_I2S:
 		fmt_val = 2;
 		break;
-	case SND_SOC_DAIFMT_LEFT_J:
-		fmt_val = 3;
-		break;
 	default:
 		dev_err(codec->dev, "Unsupported DAI format %d\n",
 			fmt & SND_SOC_DAIFMT_FORMAT_MASK);
-- 
1.7.9.5

