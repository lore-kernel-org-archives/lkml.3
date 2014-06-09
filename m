Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbaFIJF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:05:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58494 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755025AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 071/146] ARM: dts: i.MX53: Fix ipu register space size
Date: Mon,  9 Jun 2014 10:50:06 +0200
Message-Id: <8079469db8145e1d846f77151481f023b814ae11.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6d66da89bf4422c0a0693627fb3e25f74af50f92 upstream.

The IPU register space is 128MB, not 2GB.

Fixes: abed9a6bf2bb 'ARM i.MX53: Add IPU support'
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/imx53.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index 4307e80b2d2e..dc72353de0b3 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -87,7 +87,7 @@
 		ipu: ipu@18000000 {
 			#crtc-cells = <1>;
 			compatible = "fsl,imx53-ipu";
-			reg = <0x18000000 0x080000000>;
+			reg = <0x18000000 0x08000000>;
 			interrupts = <11 10>;
 			clocks = <&clks 59>, <&clks 110>, <&clks 61>;
 			clock-names = "bus", "di0", "di1";
-- 
1.9.3

