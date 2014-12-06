Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaLFPSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:18:14 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47755 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752218AbaLFPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 24/66] ASoC: fsi: remove unsupported PAUSE flag
Date: Sat,  6 Dec 2014 16:07:16 +0100
Message-Id: <befc717fc64a47bbb7cb3998f3bf8eb09c91faf1.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c1b9b9b1ad2df6144ca3fbe6989f7bd9ea5c5562 upstream.

FSI doesn't support PAUSE.
Remove SNDRV_PCM_INFO_PAUSE flags from snd_pcm_hardware info

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/sh/fsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index b33ca7cd085b..5dbf49481cae 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -1775,8 +1775,7 @@ static const struct snd_soc_dai_ops fsi_dai_ops = {
 static struct snd_pcm_hardware fsi_pcm_hardware = {
 	.info =		SNDRV_PCM_INFO_INTERLEAVED	|
 			SNDRV_PCM_INFO_MMAP		|
-			SNDRV_PCM_INFO_MMAP_VALID	|
-			SNDRV_PCM_INFO_PAUSE,
+			SNDRV_PCM_INFO_MMAP_VALID,
 	.formats		= FSI_FMTS,
 	.rates			= FSI_RATES,
 	.rate_min		= 8000,
-- 
2.1.3

