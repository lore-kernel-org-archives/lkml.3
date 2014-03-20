Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbaCTRHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:07:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48777 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809AbaCTRHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:07:45 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <galak@codeaurora.org>, <santosh.shilimkar@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <grygorii.strashko@ti.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH 1/3] ARM: dts: k2hk-evm: set ubifs partition size for 512M NAND
Date: Thu, 20 Mar 2014 19:06:22 +0200
Message-ID: <1395335184-4745-2-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>

The UBIFS partition size was incorrectly defined as for 128M NAND,
but on k2hk-evm installed NAND flash size is 512M.
Hence, correct it.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/boot/dts/k2hk-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/k2hk-evm.dts b/arch/arm/boot/dts/k2hk-evm.dts
index 1a1335b..949ef7d 100644
--- a/arch/arm/boot/dts/k2hk-evm.dts
+++ b/arch/arm/boot/dts/k2hk-evm.dts
@@ -133,7 +133,7 @@
 
 			partition@180000 {
 				label = "ubifs";
-				reg = <0x180000 0x7E80000>;
+				reg = <0x180000 0x1fe80000>;
 			};
 		};
 	};
-- 
1.8.3.2

