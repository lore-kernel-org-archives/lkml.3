Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaLIC5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:57:06 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:51094 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaLIC5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:57:05 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <ef8d62beb935c96676a89f0efe9814b3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yunzhi Li <lyz@rock-chips.com>
To: heiko@sntech.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, dianders@chromium.org,
        huangtao@rock-chips.com, zyw@rock-chips.com, cf@rock-chips.com
Cc: Yunzhi Li <lyz@rock-chips.com>
Subject: [PATCH v4 5/5] ARM: dts: Enable usb PHY on rk3288-evb board
Date: Tue,  9 Dec 2014 10:56:34 +0800
Message-Id: <1418093794-30771-1-git-send-email-lyz@rock-chips.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable usb PHY for all usb ports on rk3288-evb.

Signed-off-by: Yunzhi Li <lyz@rock-chips.com>

---

Changes in v4: None
Changes in v3: None

 arch/arm/boot/dts/rk3288-evb.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index cb83cea..992f323 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -174,6 +174,10 @@
 	};
 };
 
+&usbphy {
+	status = "okay";
+};
+
 &usb_host0_ehci {
 	status = "okay";
 };
-- 
2.0.0


