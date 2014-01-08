Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaAHKNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:13:39 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:60538 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbaAHKNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:13:37 -0500
MIME-Version: 1.0
Date: Wed, 8 Jan 2014 18:13:35 +0800
Message-ID: <CAPgLHd9fB+tA=uAfE2s5i2ygySUyqG=DNpe7RQFNOv-kBxjL2g@mail.gmail.com>
Subject: [PATCH -next] ASoC: ux500: Fix sparse non static symbol warning
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        linus.walleij@linaro.org, fabio.baltieri@linaro.org,
        lee.jones@linaro.org, arnd@arndb.de
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

sound/soc/ux500/ux500_msp_i2s.c:649:5: warning:
 symbol 'ux500_msp_i2s_of_init_msp' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/ux500/ux500_msp_i2s.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 7f2a4ac..959d7b4 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -646,9 +646,9 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 
 }
 
-int ux500_msp_i2s_of_init_msp(struct platform_device *pdev,
-			      struct ux500_msp *msp,
-			      struct msp_i2s_platform_data **platform_data)
+static int ux500_msp_i2s_of_init_msp(struct platform_device *pdev,
+				struct ux500_msp *msp,
+				struct msp_i2s_platform_data **platform_data)
 {
 	struct msp_i2s_platform_data *pdata;
 

