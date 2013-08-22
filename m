Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3HVChX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:37:23 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:33912 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3HVChV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:37:21 -0400
MIME-Version: 1.0
Date: Thu, 22 Aug 2013 10:37:20 +0800
Message-ID: <CAPgLHd9Eey5pbDjQmSquHvJY4zpDBDtp9brzWn-s5P6kaKmvpQ@mail.gmail.com>
Subject: [PATCH -next] ASoC: mmp-pcm: remove duplicated include from mmp-pcm.c
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

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/pxa/mmp-pcm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/pxa/mmp-pcm.c b/sound/soc/pxa/mmp-pcm.c
index 9a97843..8235e23 100644
--- a/sound/soc/pxa/mmp-pcm.c
+++ b/sound/soc/pxa/mmp-pcm.c
@@ -17,7 +17,6 @@
 #include <linux/dmaengine.h>
 #include <linux/platform_data/dma-mmp_tdma.h>
 #include <linux/platform_data/mmp_audio.h>
-#include <linux/dmaengine.h>
 
 #include <sound/pxa2xx-lib.h>
 #include <sound/core.h>

