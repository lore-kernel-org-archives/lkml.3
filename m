Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3APANU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:13:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:42824 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab3AOWc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 131/221] ASoC: wm5100: Remove DSP B and left justified formats
Date: Tue, 15 Jan 2013 10:50:58 -0800
Message-Id: <20130115185007.498813725@linuxfoundation.org>
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

commit 5f960294e2031d12f10c8488c3446fecbf59628d upstream.

These are not supported

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm5100.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -1279,15 +1279,9 @@ static int wm5100_set_fmt(struct snd_soc
 	case SND_SOC_DAIFMT_DSP_A:
 		mask = 0;
 		break;
-	case SND_SOC_DAIFMT_DSP_B:
-		mask = 1;
-		break;
 	case SND_SOC_DAIFMT_I2S:
 		mask = 2;
 		break;
-	case SND_SOC_DAIFMT_LEFT_J:
-		mask = 3;
-		break;
 	default:
 		dev_err(codec->dev, "Unsupported DAI format %d\n",
 			fmt & SND_SOC_DAIFMT_FORMAT_MASK);


