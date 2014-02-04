Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935336AbaBDVgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:36:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934564AbaBDVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 083/140] ASoC: wm5110: Extend SYSCLK patch file for rev D
Date: Tue,  4 Feb 2014 13:11:10 -0800
Message-Id: <20140204211039.337743610@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 34354792432b6e0a3b156819a1a19716c50d3473 upstream.

Latest evaluation of the the device has given some patch file additions
for improved performance.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm5110.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -43,6 +43,54 @@ static const struct reg_default wm5110_s
 	{ 0x3133, 0x1201 },
 	{ 0x3183, 0x1501 },
 	{ 0x31D3, 0x1401 },
+	{ 0x0049, 0x01ea },
+	{ 0x004a, 0x01f2 },
+	{ 0x0057, 0x01e7 },
+	{ 0x0058, 0x01fb },
+	{ 0x33ce, 0xc4f5 },
+	{ 0x33cf, 0x1361 },
+	{ 0x33d0, 0x0402 },
+	{ 0x33d1, 0x4700 },
+	{ 0x33d2, 0x026d },
+	{ 0x33d3, 0xff00 },
+	{ 0x33d4, 0x026d },
+	{ 0x33d5, 0x0101 },
+	{ 0x33d6, 0xc4f5 },
+	{ 0x33d7, 0x0361 },
+	{ 0x33d8, 0x0402 },
+	{ 0x33d9, 0x6701 },
+	{ 0x33da, 0xc4f5 },
+	{ 0x33db, 0x136f },
+	{ 0x33dc, 0xc4f5 },
+	{ 0x33dd, 0x134f },
+	{ 0x33de, 0xc4f5 },
+	{ 0x33df, 0x131f },
+	{ 0x33e0, 0x026d },
+	{ 0x33e1, 0x4f01 },
+	{ 0x33e2, 0x026d },
+	{ 0x33e3, 0xf100 },
+	{ 0x33e4, 0x026d },
+	{ 0x33e5, 0x0001 },
+	{ 0x33e6, 0xc4f5 },
+	{ 0x33e7, 0x0361 },
+	{ 0x33e8, 0x0402 },
+	{ 0x33e9, 0x6601 },
+	{ 0x33ea, 0xc4f5 },
+	{ 0x33eb, 0x136f },
+	{ 0x33ec, 0xc4f5 },
+	{ 0x33ed, 0x134f },
+	{ 0x33ee, 0xc4f5 },
+	{ 0x33ef, 0x131f },
+	{ 0x33f0, 0x026d },
+	{ 0x33f1, 0x4e01 },
+	{ 0x33f2, 0x026d },
+	{ 0x33f3, 0xf000 },
+	{ 0x33f6, 0xc4f5 },
+	{ 0x33f7, 0x1361 },
+	{ 0x33f8, 0x0402 },
+	{ 0x33f9, 0x4600 },
+	{ 0x33fa, 0x026d },
+	{ 0x33fb, 0xfe00 },
 };
 
 static int wm5110_sysclk_ev(struct snd_soc_dapm_widget *w,


