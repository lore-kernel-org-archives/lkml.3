Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3LBTHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:07:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3LBTGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:06:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.4 07/60] ASoC: blackfin: Fix missing break
Date: Mon,  2 Dec 2013 11:05:48 -0800
Message-Id: <20131202190331.798945107@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit afed4dbe3a043dbd833a53b6b4951e155708afd2 upstream.

Fixes: 4b2ffc205cb9 ('ASoC: Blackfin I2S: add 8-bit sample support')
Reported-by: David Binderman
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/blackfin/bf5xx-i2s.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/blackfin/bf5xx-i2s.c
+++ b/sound/soc/blackfin/bf5xx-i2s.c
@@ -111,6 +111,7 @@ static int bf5xx_i2s_hw_params(struct sn
 		bf5xx_i2s->tcr2 |= 7;
 		bf5xx_i2s->rcr2 |= 7;
 		sport_handle->wdsize = 1;
+		break;
 	case SNDRV_PCM_FORMAT_S16_LE:
 		bf5xx_i2s->tcr2 |= 15;
 		bf5xx_i2s->rcr2 |= 15;


