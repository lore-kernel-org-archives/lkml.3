Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbaCTRH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:07:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47572 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777AbaCTRHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:07:55 -0400
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
Subject: [PATCH 3/3] ARM: dts: k2hk-evm: disable subpage write for davinci nand device
Date: Thu, 20 Mar 2014 19:06:24 +0200
Message-ID: <1395335184-4745-4-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>

Add the property davinci-no-subpage-write to disable sub page write
in the nand driver.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/boot/dts/k2hk-evm.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/k2hk-evm.dts b/arch/arm/boot/dts/k2hk-evm.dts
index 949ef7d..b0498c140 100644
--- a/arch/arm/boot/dts/k2hk-evm.dts
+++ b/arch/arm/boot/dts/k2hk-evm.dts
@@ -118,6 +118,7 @@
 			nand-ecc-mode = "hw";
 			ti,davinci-ecc-bits = <4>;
 			nand-on-flash-bbt;
+			ti,davinci-no-subpage-write;
 
 			partition@0 {
 				label = "u-boot";
-- 
1.8.3.2

