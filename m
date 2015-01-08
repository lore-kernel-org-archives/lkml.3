Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbbAHCwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:52:12 -0500
Received: from regular1.263xmail.com ([211.150.99.137]:56338 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbAHCwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:52:11 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: lgirdwood@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <c50f1812a705f99bdb86865015986cca>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: lgirdwood@gmail.com, heiko@sntech.de, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, sonnyrao@chromium.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH] ASoC: rockchip: i2s:  applys rate symmetry for CPU DAI
Date: Thu,  8 Jan 2015 10:49:59 +0800
Message-Id: <1420685399-24142-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applys rate symmetry for rockchip i2s DAI.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/rockchip_i2s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 59aeec4..abd7cdd 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -339,6 +339,7 @@ static struct snd_soc_dai_driver rockchip_i2s_dai = {
 			    SNDRV_PCM_FMTBIT_S24_LE),
 	},
 	.ops = &rockchip_i2s_dai_ops,
+	.symmetric_rates = 1,
 };
 
 static const struct snd_soc_component_driver rockchip_i2s_component = {
-- 
1.9.1


