Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbaCSWQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:16:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44255 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374AbaCSWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:16:34 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 2/2] ARM: dts: keystone: disable subpage write for davinci nand device
Date: Thu, 20 Mar 2014 00:15:45 +0200
Message-ID: <1395267345-27795-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395267345-27795-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1395267345-27795-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the property davinci-no-subpage-write to disable sub page write in the
nand driver.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/boot/dts/k2hk-evm.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/k2hk-evm.dts b/arch/arm/boot/dts/k2hk-evm.dts
index 1a1335b..624520f 100644
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

