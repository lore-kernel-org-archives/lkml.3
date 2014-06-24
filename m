Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaFXUao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:30:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47589 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbaFXUah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:30:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 10/65] ARM: dts: i.MX53: Fix ipu register space size
Date: Tue, 24 Jun 2014 13:29:30 -0700
Message-Id: <1403641825-12825-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

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
index edc3f1e..9a5a1e1 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -70,7 +70,7 @@
 		ipu: ipu@18000000 {
 			#crtc-cells = <1>;
 			compatible = "fsl,imx53-ipu";
-			reg = <0x18000000 0x080000000>;
+			reg = <0x18000000 0x08000000>;
 			interrupts = <11 10>;
 		};
 
-- 
1.9.1

