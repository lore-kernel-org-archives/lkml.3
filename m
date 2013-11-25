Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3KYNZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:25:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3KYNHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 26/78] ASoC: wm_hubs: Add missing break in hp_supply_event()
Date: Mon, 25 Nov 2013 13:06:13 +0000
Message-Id: <1385384825-21681-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 268ff14525edba31da29a12a9dd693cdd6a7872e upstream.

Spotted by coverity CID 115170.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm_hubs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 932a535..d011a0d 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -502,6 +502,7 @@ static int hp_supply_event(struct snd_soc_dapm_widget *w,
 				hubs->hp_startup_mode);
 			break;
 		}
+		break;
 
 	case SND_SOC_DAPM_PRE_PMD:
 		snd_soc_update_bits(codec, WM8993_CHARGE_PUMP_1,
-- 
1.8.3.2

