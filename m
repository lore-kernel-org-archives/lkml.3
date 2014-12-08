Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaLHJrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:47:06 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:58225 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaLHJrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:47:03 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <45cc72375e1975157cfbd8afcdc6faba>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Yunzhi Li <lyz@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org, romain.perier@gmail.com
Cc: olof@lixom.net, huangtao@rock-chips.com, zyw@rock-chips.com,
        cf@rock-chips.com, linux-rockchip@lists.infradead.org,
        Yunzhi Li <lyz@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] Documentation: bindings: add doc for the Rockchip usb PHY
Date: Mon,  8 Dec 2014 17:46:25 +0800
Message-Id: <1418031988-2700-3-git-send-email-lyz@rock-chips.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1418031988-2700-1-git-send-email-lyz@rock-chips.com>
References: <1418031988-2700-1-git-send-email-lyz@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the bindings of the Rockchip usb PHY driver.

Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
---

Changes in v3: None

 .../devicetree/bindings/phy/rockchip-usb-phy.txt   | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt b/Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt
new file mode 100644
index 0000000..4574696
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt
@@ -0,0 +1,22 @@
+ROCKCHIP USB2 PHY
+
+Required properties:
+ - compatible: rockchip,rk3288-usb-phy
+ - rockchip,grf : phandle to the syscon managing the "general
+   register files"
+ - #phy-cells: must be 1
+
+Optional Properties:
+ - clocks : phandle + clock specifier for the phy clocks
+ - clock-names :
+		"usbphy0" - PHY clock for OTG controller
+		"usbphy1" - PHY clock for HOST0 controller
+		"usbphy2" - PHY clock for HOST1 controller
+
+Example:
+
+usbphy: phy {
+	#phy-cells = <1>;
+	compatible = "rockchip,rk3288-usb-phy";
+	rockchip,grf = <&grf>;
+};
-- 
2.0.0


