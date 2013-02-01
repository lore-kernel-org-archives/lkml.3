Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422765Ab3BAKvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:51:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:39231 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422738Ab3BAKvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:51:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Rattray <crattray@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 23/33] ASoC: wm2200: correct mixer values and text
Date: Fri,  1 Feb 2013 11:49:28 +0100
Message-Id: <20130201104726.299080105@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Rattray <crattray@opensource.wolfsonmicro.com>

commit a80cc734282805e15b5e023751a4d02f7ffbcc91 upstream.

Signed-off-by: Chris Rattray <crattray@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm2200.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -897,8 +897,6 @@ static const char *wm2200_mixer_texts[]
 	"EQR",
 	"LHPF1",
 	"LHPF2",
-	"LHPF3",
-	"LHPF4",
 	"DSP1.1",
 	"DSP1.2",
 	"DSP1.3",
@@ -931,7 +929,6 @@ static int wm2200_mixer_values[] = {
 	0x25,
 	0x50,   /* EQ */
 	0x51,
-	0x52,
 	0x60,   /* LHPF1 */
 	0x61,   /* LHPF2 */
 	0x68,   /* DSP1 */


