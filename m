Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaDYBve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:51:34 -0400
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:44307 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751898AbaDYBv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:51:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1534:1539:1566:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3876:3877:4321:5007:6114:6261:6642:10004:10026:10848:11026:11658:11914:12043:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: owner41_63f094593351d
X-Filterd-Recvd-Size: 1538
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 5/5] sound: tlv320aic31xx: Convert /n to \n
Date: Thu, 24 Apr 2014 18:51:03 -0700
Message-Id: <86cf3ef4915174777ea70f56c1c155f1e13fda0b.1398390579.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1398390579.git.joe@perches.com>
References: <cover.1398390579.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a newline character appropriately.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/soc/codecs/tlv320aic31xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320aic31xx.c b/sound/soc/codecs/tlv320aic31xx.c
index b93d500..2341910 100644
--- a/sound/soc/codecs/tlv320aic31xx.c
+++ b/sound/soc/codecs/tlv320aic31xx.c
@@ -377,7 +377,7 @@ static int aic31xx_dapm_power_event(struct snd_soc_dapm_widget *w,
 		reg = AIC31XX_ADCFLAG;
 		break;
 	default:
-		dev_err(w->codec->dev, "Unknown widget '%s' calling %s/n",
+		dev_err(w->codec->dev, "Unknown widget '%s' calling %s\n",
 			w->name, __func__);
 		return -EINVAL;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

