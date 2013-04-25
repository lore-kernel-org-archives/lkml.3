Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab3DYNOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:14:20 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:55403 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab3DYNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:13:40 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net
Cc: broonie@kernel.org, perex@perex.cz, tiwai@suse.de, zonque@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH v2 1/3] ASoC: spdif_transceiver: Change driver filename to spdif_transmitter.c.
Date: Thu, 25 Apr 2013 15:13:12 +0200
Message-Id: <1366895594-19596-2-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366895594-19596-1-git-send-email-marek.belisko@streamunlimited.com>
References: <1366895594-19596-1-git-send-email-marek.belisko@streamunlimited.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Transceiver usually means receiver + transmitter. This codec can do only
transmit. Update driver accordingly.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
---
 sound/soc/codecs/Makefile                          |    2 +-
 .../{spdif_transciever.c => spdif_transmitter.c}   |    0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename sound/soc/codecs/{spdif_transciever.c => spdif_transmitter.c} (100%)

diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 8cf5951..4252c35 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -51,7 +51,7 @@ snd-soc-alc5632-objs := alc5632.o
 snd-soc-sigmadsp-objs := sigmadsp.o
 snd-soc-si476x-objs := si476x.o
 snd-soc-sn95031-objs := sn95031.o
-snd-soc-spdif-tx-objs := spdif_transciever.o
+snd-soc-spdif-tx-objs := spdif_transmitter.o
 snd-soc-spdif-rx-objs := spdif_receiver.o
 snd-soc-ssm2602-objs := ssm2602.o
 snd-soc-sta32x-objs := sta32x.o
diff --git a/sound/soc/codecs/spdif_transciever.c b/sound/soc/codecs/spdif_transmitter.c
similarity index 100%
rename from sound/soc/codecs/spdif_transciever.c
rename to sound/soc/codecs/spdif_transmitter.c
-- 
1.7.9.5

