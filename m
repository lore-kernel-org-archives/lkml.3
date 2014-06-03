Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaFCMHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:07:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43528 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631AbaFCLla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 065/138] ARM: dts: i.MX53: Fix ipu register space size
Date: Tue,  3 Jun 2014 12:38:31 +0100
Message-Id: <1401795584-22664-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 6d66da89bf4422c0a0693627fb3e25f74af50f92 upstream.

The IPU register space is 128MB, not 2GB.

Fixes: abed9a6bf2bb 'ARM i.MX53: Add IPU support'
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/imx53.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index 569aa9f2c4ed..162824dbf70d 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -74,7 +74,7 @@
 		ipu: ipu@18000000 {
 			#crtc-cells = <1>;
 			compatible = "fsl,imx53-ipu";
-			reg = <0x18000000 0x080000000>;
+			reg = <0x18000000 0x08000000>;
 			interrupts = <11 10>;
 			clocks = <&clks 59>, <&clks 110>, <&clks 61>;
 			clock-names = "bus", "di0", "di1";
-- 
1.9.1

