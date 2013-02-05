Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab3BEWKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48015 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab3BEWKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:08 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Rattray <crattray@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 40/93] ASoC: wm2200: correct mixer values and text
Date: Tue,  5 Feb 2013 20:06:29 -0200
Message-Id: <1360102042-10732-41-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Rattray <crattray@opensource.wolfsonmicro.com>

commit a80cc734282805e15b5e023751a4d02f7ffbcc91 upstream.

Signed-off-by: Chris Rattray <crattray@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/codecs/wm2200.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index 86b84a1..8e0cf14 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -897,8 +897,6 @@ static const char *wm2200_mixer_texts[] = {
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
-- 
1.7.9.5

