Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbaKLEKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:10:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaKLBW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:22:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 037/319] ASoC: Intel: HSW/BDW only support S16 and S24 formats.
Date: Wed, 12 Nov 2014 10:12:55 +0900
Message-Id: <20141112010958.820217436@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Girdwood <liam.r.girdwood@linux.intel.com>

commit 2ccf3bd4f8b120936cdfc796baf40c5d3dfab68d upstream.

Fix driver with correct formats.

Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/sst-haswell-pcm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/sound/soc/intel/sst-haswell-pcm.c
+++ b/sound/soc/intel/sst-haswell-pcm.c
@@ -693,9 +693,7 @@ static int hsw_pcm_new(struct snd_soc_pc
 }
 
 #define HSW_FORMATS \
-	(SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_S24_LE | \
-	SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S16_LE |\
-	SNDRV_PCM_FMTBIT_S8)
+	(SNDRV_PCM_FMTBIT_S24_LE | SNDRV_PCM_FMTBIT_S16_LE)
 
 static struct snd_soc_dai_driver hsw_dais[] = {
 	{


