Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbaEFNgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:36:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54913 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731AbaEFNfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:52 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Dan Murphy <dmurphy@ti.com>
Subject: [TEMP PATCH 17/17] ARM: dts: dra7: Add *resets* property for PCIe dt node
Date: Tue, 6 May 2014 19:04:03 +0530
Message-ID: <1399383244-14556-18-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added *resets* and *reset-names* properies for PCIe dt node.
The documention for this node can be found @ ../bindings/pci/ti-pci.txt.

Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 20b1a09..7bc0555 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1031,6 +1031,8 @@
 			ti,hwmods = "pcie1";
 			phys = <&pcie1_phy>;
 			phy-names = "pcie-phy";
+			resets = <&prm_resets &device_reset>;
+			reset-names = "reset";
 		};
 
 		sata: sata@4a141100 {
-- 
1.7.9.5

