Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaI3Ve6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:34:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60824 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaI3Vez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:34:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 021/103] ARM: dts: i.MX53: fix apparent bug in VPU clks
Date: Tue, 30 Sep 2014 14:30:26 -0700
Message-Id: <1412112708-27356-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>

commit fa97d2f7448a2f998bca0f4d4e40d6ad49026554 upstream.

The VPU on i.MX53 has two distinct clocks for register access and
internal function.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
Fixes: fbf970f61eb9 ("ARM: dts: mx53qsb: Enable VPU support")
Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
[ kamal: backport to 3.13-stable: no imx5-clock.h so fixed hardcoded value ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/imx53.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index dc72353..6b0fd0d 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -1111,7 +1111,7 @@
 				compatible = "fsl,imx53-vpu";
 				reg = <0x63ff4000 0x1000>;
 				interrupts = <9>;
-				clocks = <&clks 63>, <&clks 63>;
+				clocks = <&clks 64>, <&clks 63>;
 				clock-names = "per", "ahb";
 				iram = <&ocram>;
 				status = "disabled";
-- 
1.9.1

