Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaG3Bca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:32:30 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:59160 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaG3Bc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:32:28 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <9b037c725628014d78681d5acbb93388>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        paulz@synopsys.com, gregkh@linuxfoundation.org, mporter@linaro.org,
        kishon@ti.com, balbi@ti.com
Cc: swarren@wwwdotorg.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kever.yang@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        cf@rock-chips.com, lyz@rock-chips.com, wulf@rock-chips.com,
        dianders@chromium.org, olof@lixom.net, sonnyrao@chromium.org
Subject: [PATCH 1/4] Documentation: dt-bindings: add dt binding info for Rockchip dwc2
Date: Tue, 29 Jul 2014 18:31:10 -0700
Message-Id: <1406683873-18194-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406683873-18194-1-git-send-email-kever.yang@rock-chips.com>
References: <963258>
 <1406683873-18194-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add necessary dwc2 binding documentation for Rockchip socs:
rk3066, rk3188 and rk3288

add dr_mode as optional properties.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---
 Documentation/devicetree/bindings/usb/dwc2.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc2.txt b/Documentation/devicetree/bindings/usb/dwc2.txt
index aa91034..eb80d7b 100644
--- a/Documentation/devicetree/bindings/usb/dwc2.txt
+++ b/Documentation/devicetree/bindings/usb/dwc2.txt
@@ -4,6 +4,9 @@ Platform DesignWare HS OTG USB 2.0 controller
 Required properties:
 - compatible : One of:
   - brcm,bcm2835-usb: The DWC2 USB controller instance in the BCM2835 SoC.
+  - rockchip,rk3066-usb: The DWC2 USB controller instance in the rk3066 Soc;
+  - "rockchip,rk3188-usb","rockchip,rk3066-usb": for rk3188 Soc;
+  - "rockchip,rk3288-usb","rockchip,rk3066-usb": for rk3288 Soc;
   - snps,dwc2: A generic DWC2 USB controller with default parameters.
 - reg : Should contain 1 register range (address and length)
 - interrupts : Should contain 1 interrupt
@@ -15,6 +18,8 @@ Optional properties:
 - phys: phy provider specifier
 - phy-names: shall be "usb2-phy"
 Refer to phy/phy-bindings.txt for generic phy consumer properties
+- dr_mode: shall be one of "host", "peripheral" and "otg"
+  Refer to usb/generic.txt
 
 Example:
 
-- 
1.7.9.5


