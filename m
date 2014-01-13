Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbaAMQxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:53:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaAMQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 056/208] ASoC: wm5110: Correct HPOUT3 DAPM route typo
Date: Mon, 13 Jan 2014 15:58:17 +0000
Message-Id: <1389628849-1614-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 280484e708a3cc38fe6807718caa460e744c0b20 upstream.

Reported-by: Kyung-Kwee Ryu <kyung-kwee.ryu@wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm5110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 18cdee7..c923776 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -1032,7 +1032,7 @@ static const struct snd_soc_dapm_route wm5110_dapm_routes[] = {
 	{ "HPOUT2R", NULL, "OUT2R" },
 
 	{ "HPOUT3L", NULL, "OUT3L" },
-	{ "HPOUT3R", NULL, "OUT3L" },
+	{ "HPOUT3R", NULL, "OUT3R" },
 
 	{ "SPKOUTLN", NULL, "OUT4L" },
 	{ "SPKOUTLP", NULL, "OUT4L" },
-- 
1.8.3.2

