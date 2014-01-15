Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaAOWFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:05:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41445 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaAOWAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 074/166] ASoC: wm5110: Correct HPOUT3 DAPM route typo
Date: Wed, 15 Jan 2014 13:51:28 -0800
Message-Id: <1389822780-4729-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 280484e708a3cc38fe6807718caa460e744c0b20 upstream.

Reported-by: Kyung-Kwee Ryu <kyung-kwee.ryu@wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm5110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index e0bb6dc..bfaf96b 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -860,7 +860,7 @@ static const struct snd_soc_dapm_route wm5110_dapm_routes[] = {
 	{ "HPOUT2R", NULL, "OUT2R" },
 
 	{ "HPOUT3L", NULL, "OUT3L" },
-	{ "HPOUT3R", NULL, "OUT3L" },
+	{ "HPOUT3R", NULL, "OUT3R" },
 
 	{ "SPKOUTLN", NULL, "OUT4L" },
 	{ "SPKOUTLP", NULL, "OUT4L" },
-- 
1.8.3.2

