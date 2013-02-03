Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3BCOyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:54:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34069 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393Ab3BCOyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:46 -0500
Message-Id: <20130203144645.213994829@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 013/128] ASoC: wm5100: Remove DSP B and left justified formats
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 5f960294e2031d12f10c8488c3446fecbf59628d upstream.

These are not supported

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm5100.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 5a5f369..54397a5 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -1279,15 +1279,9 @@ static int wm5100_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	case SND_SOC_DAIFMT_DSP_A:
 		mask = 0;
 		break;
-	case SND_SOC_DAIFMT_DSP_B:
-		mask = 1;
-		break;
 	case SND_SOC_DAIFMT_I2S:
 		mask = 2;
 		break;
-	case SND_SOC_DAIFMT_LEFT_J:
-		mask = 3;
-		break;
 	default:
 		dev_err(codec->dev, "Unsupported DAI format %d\n",
 			fmt & SND_SOC_DAIFMT_FORMAT_MASK);


