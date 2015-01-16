Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbbAPHU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:20:27 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:34310 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752498AbbAPHUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:20:02 -0500
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, <alsa-devel@alsa-project.org>,
        <linux-sound@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 2/2] ASoC: atmel_ssc_dai: remove clock pin comments
Date: Fri, 16 Jan 2015 15:19:44 +0800
Message-ID: <1421392784-32298-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.3.0.rc0
In-Reply-To: <1421392784-32298-1-git-send-email-voice.shen@atmel.com>
References: <1421392784-32298-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the clock can be get from TK/RK pin, so remove the comments.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 sound/soc/atmel/atmel_ssc_dai.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index e691aab..198661b 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -452,10 +452,6 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 	case SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBM_CFM:
 		/*
 		 * I2S format, CODEC supplies BCLK and LRC clocks.
-		 *
-		 * The SSC transmit clock is obtained from the BCLK signal on
-		 * on the TK line, and the SSC receive clock is
-		 * generated from the transmit clock.
 		 */
 		rcmr =	  SSC_BF(RCMR_PERIOD, 0)
 			| SSC_BF(RCMR_STTDLY, START_DELAY)
-- 
2.3.0.rc0

