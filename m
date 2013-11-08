Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab3KHCRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab3KHCQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 82/91] ASoC: wm_hubs: Add missing break in hp_supply_event()
Date: Thu,  7 Nov 2013 18:15:37 -0800
Message-Id: <1383876946-2396-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 268ff14525edba31da29a12a9dd693cdd6a7872e upstream.

Spotted by coverity CID 115170.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm_hubs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 867ae97..e7d0aee 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -527,6 +527,7 @@ static int hp_supply_event(struct snd_soc_dapm_widget *w,
 				hubs->hp_startup_mode);
 			break;
 		}
+		break;
 
 	case SND_SOC_DAPM_PRE_PMD:
 		snd_soc_update_bits(codec, WM8993_CHARGE_PUMP_1,
-- 
1.8.1.2

