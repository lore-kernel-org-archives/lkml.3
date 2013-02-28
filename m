Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577Ab3B1PTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:19:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41972 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab3B1Oqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Rattray <crattray@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 027/139] ASoC: wm2200: correct IN2L and IN3L digital mute
Date: Thu, 28 Feb 2013 14:42:57 +0000
Message-Id: <1362062689-2567-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Rattray <crattray@opensource.wolfsonmicro.com>

commit 0d2b6422529a26ac4dee06196524ba9da70cf735 upstream.

Signed-off-by: Chris Rattray <crattray@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm2200.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index 8e0cf14..9932aac 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -990,9 +990,9 @@ SOC_DOUBLE_R_TLV("IN3 Volume", WM2200_IN3L_CONTROL, WM2200_IN3R_CONTROL,
 
 SOC_DOUBLE_R("IN1 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_1L,
 	     WM2200_ADC_DIGITAL_VOLUME_1R, WM2200_IN1L_MUTE_SHIFT, 1, 1),
-SOC_DOUBLE_R("IN2 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_1L,
+SOC_DOUBLE_R("IN2 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_2L,
 	     WM2200_ADC_DIGITAL_VOLUME_2R, WM2200_IN2L_MUTE_SHIFT, 1, 1),
-SOC_DOUBLE_R("IN3 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_1L,
+SOC_DOUBLE_R("IN3 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_3L,
 	     WM2200_ADC_DIGITAL_VOLUME_3R, WM2200_IN3L_MUTE_SHIFT, 1, 1),
 
 SOC_DOUBLE_R_TLV("IN1 Digital Volume", WM2200_ADC_DIGITAL_VOLUME_1L,
-- 
1.8.1.2

