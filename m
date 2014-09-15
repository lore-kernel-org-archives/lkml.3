Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaIOTfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:35:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaIOT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie+linaro@kernel.org>
Subject: [PATCH 3.16 090/158] ASoC: omap-twl4030: Fix typo in 2nd dai links platform_name
Date: Mon, 15 Sep 2014 12:25:29 -0700
Message-Id: <20140915192545.583583011@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit fdaf42c0105a24de8aefa60f6f7360842c4e673e upstream.

The platform_name should be omap-mcasp3 for the 2nd link which is used for
voice connection.

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie+linaro@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/omap/omap-twl4030.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/omap/omap-twl4030.c
+++ b/sound/soc/omap/omap-twl4030.c
@@ -260,7 +260,7 @@ static struct snd_soc_dai_link omap_twl4
 		.stream_name = "TWL4030 Voice",
 		.cpu_dai_name = "omap-mcbsp.3",
 		.codec_dai_name = "twl4030-voice",
-		.platform_name = "omap-mcbsp.2",
+		.platform_name = "omap-mcbsp.3",
 		.codec_name = "twl4030-codec",
 		.dai_fmt = SND_SOC_DAIFMT_DSP_A | SND_SOC_DAIFMT_IB_NF |
 			   SND_SOC_DAIFMT_CBM_CFM,


