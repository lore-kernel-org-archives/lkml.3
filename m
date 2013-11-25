Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3KYN6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:58:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58916 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739Ab3KYNyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:54:00 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@linaro.org>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.96717894@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 82/87] ASoC: wm_hubs: Add missing break in
 hp_supply_event()
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 268ff14525edba31da29a12a9dd693cdd6a7872e upstream.

Spotted by coverity CID 115170.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm_hubs.c | 1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -414,6 +414,7 @@ static int hp_supply_event(struct snd_so
 				hubs->hp_startup_mode);
 			break;
 		}
+		break;
 
 	case SND_SOC_DAPM_PRE_PMD:
 		snd_soc_update_bits(codec, WM8993_CHARGE_PUMP_1,

