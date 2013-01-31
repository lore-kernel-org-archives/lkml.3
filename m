Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3AaLWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:22:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41767 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab3AaLWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:22:37 -0500
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <tony@atomide.com>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <rob@landley.net>,
        <grant.likely@secretlab.ca>
Subject: [PATCH v3 2/4] ASoC: davinci: update machine driver dapm routes
Date: Thu, 31 Jan 2013 16:53:11 +0530
Message-ID: <1359631394-9511-3-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359631394-9511-1-git-send-email-gururaja.hebbar@ti.com>
References: <1359631394-9511-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now since micbias is converted to supply widget, updated machine driver
as well.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
---
Changes in v3
	 - New patch

:100644 100644 d55e647... 484b22c... M	sound/soc/davinci/davinci-evm.c
 sound/soc/davinci/davinci-evm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
index d55e647..484b22c 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -116,9 +116,9 @@ static const struct snd_soc_dapm_route audio_map[] = {
 	{"Line Out", NULL, "RLOUT"},
 
 	/* Mic connected to (MIC3L | MIC3R) */
-	{"MIC3L", NULL, "Mic Bias 2V"},
-	{"MIC3R", NULL, "Mic Bias 2V"},
-	{"Mic Bias 2V", NULL, "Mic Jack"},
+	{"MIC3L", NULL, "Mic Bias"},
+	{"MIC3R", NULL, "Mic Bias"},
+	{"Mic Bias", NULL, "Mic Jack"},
 
 	/* Line In connected to (LINE1L | LINE2L), (LINE1R | LINE2R) */
 	{"LINE1L", NULL, "Line In"},
-- 
1.7.9.5

