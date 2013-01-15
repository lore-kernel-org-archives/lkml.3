Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3APAOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:14:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:42711 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418Ab3AOWcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 125/221] ASoC: arizona: Remove DSP B and left justified AIF modes
Date: Tue, 15 Jan 2013 10:50:52 -0800
Message-Id: <20130115185007.049183891@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit d71753e22b24548911b377db28f80870cf50d07b upstream.

These are not supported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/arizona.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -409,15 +409,9 @@ static int arizona_set_fmt(struct snd_so
 	case SND_SOC_DAIFMT_DSP_A:
 		mode = 0;
 		break;
-	case SND_SOC_DAIFMT_DSP_B:
-		mode = 1;
-		break;
 	case SND_SOC_DAIFMT_I2S:
 		mode = 2;
 		break;
-	case SND_SOC_DAIFMT_LEFT_J:
-		mode = 3;
-		break;
 	default:
 		arizona_aif_err(dai, "Unsupported DAI format %d\n",
 				fmt & SND_SOC_DAIFMT_FORMAT_MASK);


