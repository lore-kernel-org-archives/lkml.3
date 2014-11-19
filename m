Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbaKSWXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:23:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbaKSUyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.17 072/141] ARM: dts: am335x-evm: Fix 5th NAND partitions name
Date: Wed, 19 Nov 2014 12:51:35 -0800
Message-Id: <20141119205153.028614636@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/am335x-evm.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


