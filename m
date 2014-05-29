Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaE2GlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:41:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56719 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999AbaE2Gkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:40:43 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        <kishon@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [TEMP PATCH v2 18/18] ARM: dts: dra7: Add *resets* property for PCIe dt node
Date: Thu, 29 May 2014 12:08:20 +0530
Message-ID: <1401345500-20188-19-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401345500-20188-1-git-send-email-kishon@ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
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
index 1239f0d..03494b2 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1055,6 +1055,8 @@
 				#interrupt-cells = <1>;
 				num-lanes = <1>;
 				ti,hwmods = "pcie1";
+				resets = <&prm_resets &device_reset>;
+				reset-names = "reset";
 				phys = <&pcie1_phy>;
 				phy-names = "pcie-phy0";
 				interrupt-map-mask = <0 0 0 7>;
-- 
1.7.9.5

