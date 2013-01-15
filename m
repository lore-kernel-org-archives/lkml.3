Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab3APAMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:12:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:42878 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab3AOWcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 128/221] ASoC: wm2200: Remove DSP B and left justified AIF modes
Date: Tue, 15 Jan 2013 10:50:55 -0800
Message-Id: <20130115185007.270604305@linuxfoundation.org>
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

commit 0cc411b934c4317b363d1af993549f391852b980 upstream.

These are not supported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm2200.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -1380,15 +1380,9 @@ static int wm2200_set_fmt(struct snd_soc
 	case SND_SOC_DAIFMT_DSP_A:
 		fmt_val = 0;
 		break;
-	case SND_SOC_DAIFMT_DSP_B:
-		fmt_val = 1;
-		break;
 	case SND_SOC_DAIFMT_I2S:
 		fmt_val = 2;
 		break;
-	case SND_SOC_DAIFMT_LEFT_J:
-		fmt_val = 3;
-		break;
 	default:
 		dev_err(codec->dev, "Unsupported DAI format %d\n",
 			fmt & SND_SOC_DAIFMT_FORMAT_MASK);


