Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbbAEM27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:28:59 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:56493 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133AbbAEM25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:28:57 -0500
X-Listener-Flag: 11101
From: Eddie Huang <eddie.huang@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: <srv_heupstream@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yingjoe.chen@mediatek.com>,
        <yh.chen@mediatek.com>, Eddie Huang <eddie.huang@mediatek.com>
Subject: [PATCH] ARM: mediatek: dts: Add UART dts for MT8127 and MT8135 boards
Date: Mon, 5 Jan 2015 20:28:38 +0800
Message-ID: <1420460918-24380-1-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enable UART for MT8127 moose board and MT8135 evalution board.
Adding the dts, these two boards can show log and shell prompts.
This patch base on my previous MT8135/MT8127 SoC UART dtsi patch [1] and
Matthias's modification to disable SoC UART by default.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/312311.html

Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
---
 arch/arm/boot/dts/mt8127-moose.dts | 4 ++++
 arch/arm/boot/dts/mt8135-evbp1.dts | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/mt8127-moose.dts b/arch/arm/boot/dts/mt8127-moose.dts
index 13cba0e..073e295 100644
--- a/arch/arm/boot/dts/mt8127-moose.dts
+++ b/arch/arm/boot/dts/mt8127-moose.dts
@@ -23,3 +23,7 @@
 		reg = <0 0x80000000 0 0x40000000>;
 	};
 };
+
+&uart0 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/mt8135-evbp1.dts b/arch/arm/boot/dts/mt8135-evbp1.dts
index a5adf97..3667738 100644
--- a/arch/arm/boot/dts/mt8135-evbp1.dts
+++ b/arch/arm/boot/dts/mt8135-evbp1.dts
@@ -23,3 +23,7 @@
 		reg = <0 0x80000000 0 0x40000000>;
 	};
 };
+
+&uart3 {
+	status = "okay";
+};
-- 
1.8.1.1.dirty

