Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaAIOXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:23:04 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:47890 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaAIOWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:22:36 -0500
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 22:22:35 +0800
Message-ID: <CAPgLHd_bNPEJmkjtmbeDrtmVMo5G7ELNCuyKuwT7Qa=weqh8kA@mail.gmail.com>
Subject: [PATCH -next] ASoC: wm_adsp: Fix sparse non static symbol warning
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        dp@opensource.wolfsonmicro.com, ckeepax@opensource.wolfsonmicro.com
Cc: yongjun_wei@trendmicro.com.cn, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

sound/soc/codecs/wm_adsp.c:1500:6: warning:
 symbol 'wm_adsp2_boot_work' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/codecs/wm_adsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 41669ad..444626f 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1497,7 +1497,7 @@ static int wm_adsp2_ena(struct wm_adsp *dsp)
 	return 0;
 }
 
-void wm_adsp2_boot_work(struct work_struct *work)
+static void wm_adsp2_boot_work(struct work_struct *work)
 {
 	struct wm_adsp *dsp = container_of(work,
 					   struct wm_adsp,

