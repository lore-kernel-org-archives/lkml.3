Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3GBJ0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:26:50 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:61137 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3GBJ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:26:41 -0400
MIME-Version: 1.0
Date: Tue, 2 Jul 2013 17:26:40 +0800
Message-ID: <CAPgLHd_CJUYf8Ry=J9Y8ZPSrCgqPLTj74rDr__bxoymQ8GR_1A@mail.gmail.com>
Subject: [PATCH] ASoC: ttc_dkb: add .owner to struct snd_soc_card
From: Wei Yongjun <weiyj.lk@gmail.com>
To: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add missing .owner of struct snd_soc_card. This prevents the
module from being removed from underneath its users.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/pxa/ttc-dkb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/pxa/ttc-dkb.c b/sound/soc/pxa/ttc-dkb.c
index f4ea4f6..13c9ee0 100644
--- a/sound/soc/pxa/ttc-dkb.c
+++ b/sound/soc/pxa/ttc-dkb.c
@@ -122,6 +122,7 @@ static struct snd_soc_dai_link ttc_pm860x_hifi_dai[] = {
 /* ttc/td audio machine driver */
 static struct snd_soc_card ttc_dkb_card = {
 	.name = "ttc-dkb-hifi",
+	.owner = THIS_MODULE,
 	.dai_link = ttc_pm860x_hifi_dai,
 	.num_links = ARRAY_SIZE(ttc_pm860x_hifi_dai),
 

