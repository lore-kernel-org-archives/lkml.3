Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbbAAUiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 15:38:24 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:65517 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbAAUiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 15:38:23 -0500
From: Shakil A Khan <shakilk1729@gmail.com>
To: tiwai@suse.de
Cc: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Shakil A Khan <shakilk1729@gmail.com>
Subject: [PATCH] Removed unused variable i from sound/soc/soc-pcm.c Signed-off-by: Shakil A Khan <shakilk1729@gmail.com>
Date: Thu,  1 Jan 2015 09:01:21 -0800
Message-Id: <1420131681-74211-1-git-send-email-shakilk1729@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 sound/soc/soc-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index d6e8d6b..6b0136e 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -304,7 +304,7 @@ static bool soc_pcm_has_symmetry(struct snd_pcm_substream *substream)
 static void soc_pcm_set_msb(struct snd_pcm_substream *substream, int bits)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	int ret, i;
+	int ret;
 
 	if (!bits)
 		return;
-- 
1.9.1

