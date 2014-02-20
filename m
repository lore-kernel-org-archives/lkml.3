Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaBTOxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:53:16 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:59331 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaBTOtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:49:53 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 01/11] ARM: shmobile: r8a7791 dtsi: Fix typo in msiof2 clock output name
Date: Thu, 20 Feb 2014 15:49:29 +0100
Message-Id: <1392907779-22053-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Introduced in commit cded80f869aef94853e056ab9c21e305b0c26138 ("ARM:
shmobile: r8a7791: Add MSIOF clocks in device tree").

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/boot/dts/r8a7791.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index 1ab4f3d5a8c2..224f4a7ee52a 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -667,7 +667,7 @@
 				R8A7791_CLK_MSIOF1 R8A7791_CLK_SCIFB2
 			>;
 			clock-output-names =
-				"scifa2", "scifa1", "scifa0", "misof2", "scifb0",
+				"scifa2", "scifa1", "scifa0", "msiof2", "scifb0",
 				"scifb1", "msiof1", "scifb2";
 		};
 		mstp3_clks: mstp3_clks@e615013c {
-- 
1.7.9.5

