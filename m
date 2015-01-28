Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbbA1WUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:20:21 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41283 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbbA1UMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:12:50 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Simon Glass <sjg@chromium.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: [PATCH v3 06/10] ASoC: tegra: Add a control for the headphone switch
Date: Wed, 28 Jan 2015 11:51:04 +0100
Message-Id: <1422442278-10405-7-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be used by userspace when the headphones jack is plugged in.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 sound/soc/tegra/tegra_max98090.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/tegra/tegra_max98090.c b/sound/soc/tegra/tegra_max98090.c
index af3fb99..8df71a4 100644
--- a/sound/soc/tegra/tegra_max98090.c
+++ b/sound/soc/tegra/tegra_max98090.c
@@ -136,6 +136,7 @@ static const struct snd_soc_dapm_widget tegra_max98090_dapm_widgets[] = {
 };
 
 static const struct snd_kcontrol_new tegra_max98090_controls[] = {
+	SOC_DAPM_PIN_SWITCH("Headphones"),
 	SOC_DAPM_PIN_SWITCH("Speakers"),
 };
 
-- 
1.9.3

