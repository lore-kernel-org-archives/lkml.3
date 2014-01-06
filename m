Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaAFWix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaAFWis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kyung-Kwee Ryu <kyung-kwee.ryu@wolfsonmicro.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 016/144] ASoC: wm5110: Correct HPOUT3 DAPM route typo
Date: Mon,  6 Jan 2014 14:36:17 -0800
Message-Id: <20140106223745.793016286@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 280484e708a3cc38fe6807718caa460e744c0b20 upstream.

Reported-by: Kyung-Kwee Ryu <kyung-kwee.ryu@wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm5110.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -1031,7 +1031,7 @@ static const struct snd_soc_dapm_route w
 	{ "HPOUT2R", NULL, "OUT2R" },
 
 	{ "HPOUT3L", NULL, "OUT3L" },
-	{ "HPOUT3R", NULL, "OUT3L" },
+	{ "HPOUT3R", NULL, "OUT3R" },
 
 	{ "SPKOUTLN", NULL, "OUT4L" },
 	{ "SPKOUTLP", NULL, "OUT4L" },


