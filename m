Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab3FDRGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:06:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab3FDRDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 63/75] ASoC: wm5110: Correct DSP4R Mixer control name
Date: Tue,  4 Jun 2013 09:55:47 -0700
Message-Id: <1370364959-9475-64-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 39d4ecdb711ba44e0aa0b2f3db74ed5ac97abe21 upstream.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm5110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 7a09096..ccbdc46 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -177,7 +177,7 @@ ARIZONA_MIXER_CONTROLS("DSP2R", ARIZONA_DSP2RMIX_INPUT_1_SOURCE),
 ARIZONA_MIXER_CONTROLS("DSP3L", ARIZONA_DSP3LMIX_INPUT_1_SOURCE),
 ARIZONA_MIXER_CONTROLS("DSP3R", ARIZONA_DSP3RMIX_INPUT_1_SOURCE),
 ARIZONA_MIXER_CONTROLS("DSP4L", ARIZONA_DSP4LMIX_INPUT_1_SOURCE),
-ARIZONA_MIXER_CONTROLS("DSP5R", ARIZONA_DSP4RMIX_INPUT_1_SOURCE),
+ARIZONA_MIXER_CONTROLS("DSP4R", ARIZONA_DSP4RMIX_INPUT_1_SOURCE),
 
 ARIZONA_MIXER_CONTROLS("Mic", ARIZONA_MICMIX_INPUT_1_SOURCE),
 ARIZONA_MIXER_CONTROLS("Noise", ARIZONA_NOISEMIX_INPUT_1_SOURCE),
-- 
1.8.1.2

