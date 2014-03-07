Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaCGMRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:17:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54035 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbaCGMRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:17:41 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <dmaengine@vger.kernel.org>
CC: <santosh.shilimkar@ti.com>, <rnayak@ti.com>, <nsekhar@ti.com>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <nm@ti.com>
Subject: [RFC PATCH 6/9] arm: dts: dra: Add dma crossbar node
Date: Fri, 7 Mar 2014 17:46:13 +0530
Message-ID: <1394194576-23741-7-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
References: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the crossbar node.

Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 1fd75aa..f84991b 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -170,6 +170,13 @@
 			#dma-requests = <127>;
 		};
 
+		dmacb: crossbar@4a020000 {
+			compatible = "ti,dma-crossbar";
+			reg = <0x4a002b78 0x100>;
+			ti,dma-reqs = <160>;
+			ti,reg-size = <2>;
+		};
+
 		gpio1: gpio@4ae10000 {
 			compatible = "ti,omap4-gpio";
 			reg = <0x4ae10000 0x200>;
-- 
1.7.9.5

