Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3KAKDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:03:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47306 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176Ab3KAKDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:03:01 -0400
Date: Fri, 1 Nov 2013 10:02:58 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, perex@perex.cz
Subject: [PATCH 2/2] ASoC: wm8962: Add EQ coefficient support
Message-ID: <20131101100258.GC1901@opensource.wolfsonmicro.com>
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
 sound/soc/codecs/wm8962.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 2b04497..150d003 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1757,6 +1757,9 @@ SOC_DOUBLE_R_TLV("EQ4 Volume", WM8962_EQ3, WM8962_EQ23,
 		 WM8962_EQL_B4_GAIN_SHIFT, 31, 0, eq_tlv),
 SOC_DOUBLE_R_TLV("EQ5 Volume", WM8962_EQ3, WM8962_EQ23,
 		 WM8962_EQL_B5_GAIN_SHIFT, 31, 0, eq_tlv),
+SND_SOC_BYTES("EQL Coefficients", WM8962_EQ4, 18),
+SND_SOC_BYTES("EQR Coefficients", WM8962_EQ24, 18),
+
 
 SOC_SINGLE("3D Switch", WM8962_THREED1, 0, 1, 0),
 SND_SOC_BYTES_MASK("3D Coefficients", WM8962_THREED1, 4, WM8962_THREED_ENA),
-- 
1.7.2.5


