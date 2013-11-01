Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab3KAKCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:02:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47291 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372Ab3KAKCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:02:12 -0400
Date: Fri, 1 Nov 2013 10:02:10 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, perex@perex.cz
Subject: [PATCH 1/2] ASoC: wm8962: Add ALC coefficient support
Message-ID: <20131101100210.GB1901@opensource.wolfsonmicro.com>
References: <20131101100051.GA1901@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101100051.GA1901@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm8962.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index c9ff713..2b04497 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1774,6 +1774,11 @@ WM8962_DSP2_ENABLE("HPF2 Switch", WM8962_HPF2_ENA_SHIFT),
 SND_SOC_BYTES("HPF Coefficients", WM8962_LHPF2, 1),
 WM8962_DSP2_ENABLE("HD Bass Switch", WM8962_HDBASS_ENA_SHIFT),
 SND_SOC_BYTES("HD Bass Coefficients", WM8962_HDBASS_AI_1, 30),
+
+SOC_DOUBLE("ALC Switch", WM8962_ALC1, WM8962_ALCL_ENA_SHIFT,
+		WM8962_ALCR_ENA_SHIFT, 1, 0),
+SND_SOC_BYTES_MASK("ALC Coefficients", WM8962_ALC1, 4,
+		WM8962_ALCL_ENA_MASK | WM8962_ALCR_ENA_MASK),
 };
 
 static const struct snd_kcontrol_new wm8962_spk_mono_controls[] = {
-- 
1.7.2.5

