Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab3AOXkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:40:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:46227 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051Ab3AOWu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 073/171] ASoC: wm2200: Remove DSP B and left justified AIF modes
Date: Tue, 15 Jan 2013 14:43:58 -0800
Message-Id: <20130115224318.667359339@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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


