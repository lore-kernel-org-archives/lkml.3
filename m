Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab3CLUIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:08:41 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:59991 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755095Ab3CLUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:08:40 -0400
Message-ID: <1363118918.3137.143.camel@x61.thuisdomein>
Subject: [PATCH] ASoC: codecs: remove hidden prompt
From: Paul Bolle <pebolle@tiscali.nl>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 21:08:38 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2013 20:08:39.0336 (UTC) FILETIME=[62FB0280:01CE1F5D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol SND_SOC_OF_SIMPLE got removed in commit
f0fba2ad1b6b53d5360125c41953b7afcd6deff0 ("ASoC: multi-component - ASoC
Multi-Component Support"). But that commit missed one instance. Remove
it now, together with the prompt it has effectively hidden ever since.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Lightly tested (ie, "make menuconfig" still worked).

 sound/soc/codecs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 45b7256..350b864 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -324,7 +324,7 @@ config SND_SOC_TLV320AIC23
 	tristate
 
 config SND_SOC_TLV320AIC26
-	tristate "TI TLV320AIC26 Codec support" if SND_SOC_OF_SIMPLE
+	tristate
 	depends on SPI
 
 config SND_SOC_TLV320AIC32X4
-- 
1.7.11.7

