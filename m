Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab3CZGrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:47:11 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:48821 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab3CZGrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:47:10 -0400
MIME-Version: 1.0
Date: Tue, 26 Mar 2013 14:47:08 +0800
Message-ID: <CAPgLHd9a+DV9cLbbNDp=TaVxDCjdK1oE1LXf0g4WOQ6bVgqGEw@mail.gmail.com>
Subject: [PATCH -next] ASoC: arizona: remove duplicated include from arizona.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: broonie@opensource.wolfsonmicro.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/codecs/arizona.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index 26e1579..c979ff2 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -14,7 +14,6 @@
 #include <linux/gcd.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
-#include <linux/delay.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/tlv.h>

