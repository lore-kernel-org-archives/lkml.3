Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360Ab3B0ARX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:17:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760412Ab3B0AJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Rattray <crattray@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 57/86] ASoC: wm2200: correct IN2L and IN3L digital mute
Date: Tue, 26 Feb 2013 16:08:05 -0800
Message-Id: <20130226235918.829793802@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Rattray <crattray@opensource.wolfsonmicro.com>

commit 0d2b6422529a26ac4dee06196524ba9da70cf735 upstream.

Signed-off-by: Chris Rattray <crattray@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm2200.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -990,9 +990,9 @@ SOC_DOUBLE_R_TLV("IN3 Volume", WM2200_IN
 
 SOC_DOUBLE_R("IN1 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_1L,
 	     WM2200_ADC_DIGITAL_VOLUME_1R, WM2200_IN1L_MUTE_SHIFT, 1, 1),
-SOC_DOUBLE_R("IN2 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_1L,
+SOC_DOUBLE_R("IN2 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_2L,
 	     WM2200_ADC_DIGITAL_VOLUME_2R, WM2200_IN2L_MUTE_SHIFT, 1, 1),
-SOC_DOUBLE_R("IN3 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_1L,
+SOC_DOUBLE_R("IN3 Digital Switch", WM2200_ADC_DIGITAL_VOLUME_3L,
 	     WM2200_ADC_DIGITAL_VOLUME_3R, WM2200_IN3L_MUTE_SHIFT, 1, 1),
 
 SOC_DOUBLE_R_TLV("IN1 Digital Volume", WM2200_ADC_DIGITAL_VOLUME_1L,


