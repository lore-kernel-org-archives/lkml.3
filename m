Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965278AbaFQVsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966109AbaFQVsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 104/212] ARM: dts: i.MX53: Fix ipu register space size
Date: Tue, 17 Jun 2014 14:43:18 -0700
Message-Id: <1403041506-13646-105-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 6d66da89bf4422c0a0693627fb3e25f74af50f92 upstream.

The IPU register space is 128MB, not 2GB.

Fixes: abed9a6bf2bb 'ARM i.MX53: Add IPU support'
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/imx53.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index 4307e80..dc72353 100644
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
1.9.1

