Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaKYKn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59282 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaKYKnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 252/254] ARM: dts: am335x-evm: Fix 5th NAND partition's name
Date: Tue, 25 Nov 2014 10:40:02 +0000
Message-Id: <1416912004-5928-253-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit a8ead0ecb9d4ce472f4cdab936d6f18e41e3a9ee upstream.

The 5th NAND partition should be named "NAND.u-boot-spl-os"
instead of "NAND.u-boot-spl". This is to be consistent with other
TI boards as well as u-boot.

Fixes: 91994facdd2d ("ARM: dts: am335x-evm: NAND: update MTD partition table")

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/am335x-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index e2156a583de7..c4b968f0feb5 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -489,7 +489,7 @@
 			reg = <0x00060000 0x00020000>;
 		};
 		partition@4 {
-			label = "NAND.u-boot-spl";
+			label = "NAND.u-boot-spl-os";
 			reg = <0x00080000 0x00040000>;
 		};
 		partition@5 {
-- 
2.1.0

