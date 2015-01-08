Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbbAHV5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 16:57:21 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:41689 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbAHV5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 16:57:20 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        stable@vger.kernel.org
Subject: [PATCH] ASoC: pcm512x: Fix DSP program selection
Date: Thu,  8 Jan 2015 22:56:30 +0100
Message-Id: <1420754190-6309-1-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

The DSP programs are listed out of order.

Signed-off-by: Peter Rosin <peda@axentia.se>
Cc: stable@vger.kernel.org
---
 sound/soc/codecs/pcm512x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index 0c8aefab404c..640c99198cda 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -188,8 +188,8 @@ static const DECLARE_TLV_DB_SCALE(boost_tlv, 0, 80, 0);
 static const char * const pcm512x_dsp_program_texts[] = {
 	"FIR interpolation with de-emphasis",
 	"Low latency IIR with de-emphasis",
-	"Fixed process flow",
 	"High attenuation with de-emphasis",
+	"Fixed process flow",
 	"Ringing-less low latency FIR",
 };
 
-- 
1.7.10.4

