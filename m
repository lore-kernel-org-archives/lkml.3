Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbaLKDPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:15:43 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:10537 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933251AbaLKDO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:14:57 -0500
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>, Mark Brown <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-sound@vger.kernel.org>, Alexander Morozov <linux@meltdown.ru>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 2/3] ARM: at91: sama5d3xek/dt: use dt ids for wm8904
Date: Thu, 11 Dec 2014 11:14:40 +0800
Message-ID: <1418267681-4091-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
In-Reply-To: <1418267681-4091-1-git-send-email-voice.shen@atmel.com>
References: <1418267681-4091-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Morozov <linux@meltdown.ru>

Using the wm8904 device tree compatible string.

Signed-off-by: Alexander Morozov <linux@meltdown.ru>
Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 arch/arm/boot/dts/sama5d3xmb.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
index 49c10d3..2a1aa58 100644
--- a/arch/arm/boot/dts/sama5d3xmb.dtsi
+++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
@@ -45,7 +45,7 @@
 			 */
 			i2c0: i2c@f0014000 {
 				wm8904: wm8904@1a {
-					compatible = "wm8904";
+					compatible = "wlf,wm8904";
 					reg = <0x1a>;
 					clocks = <&pck0>;
 					clock-names = "mclk";
-- 
2.1.0.24.g4109c28

