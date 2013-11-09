Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab3KIHVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:21:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab3KIGvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 41/74] ASoC: wm_hubs: Add missing break in hp_supply_event()
Date: Fri,  8 Nov 2013 22:51:46 -0800
Message-Id: <20131109065116.411600079@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 268ff14525edba31da29a12a9dd693cdd6a7872e upstream.

Spotted by coverity CID 115170.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_hubs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -530,6 +530,7 @@ static int hp_supply_event(struct snd_so
 				hubs->hp_startup_mode);
 			break;
 		}
+		break;
 
 	case SND_SOC_DAPM_PRE_PMD:
 		snd_soc_update_bits(codec, WM8993_CHARGE_PUMP_1,


