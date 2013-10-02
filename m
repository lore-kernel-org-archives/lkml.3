Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3JBR7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:59:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33680 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3JBR7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:59:01 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mugunthanvnm@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH] ARM: dts: AM33XX: add ethernet alias's for am33xx
Date: Wed, 2 Oct 2013 12:58:33 -0500
Message-ID: <1380736713-24678-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the alias for ethernet0 and ethernet1 so that uBoot
can set the MAC address appropriately.

Currently uBoot cannot find the alias and there for does not set the
MAC address.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 553adc6..8aabaa0 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -30,6 +30,8 @@
 		usb1 = &usb1;
 		phy0 = &usb0_phy;
 		phy1 = &usb1_phy;
+		ethernet0 = &cpsw_emac0;
+		ethernet1 = &cpsw_emac1;
 	};
 
 	cpus {
-- 
1.7.9.5

