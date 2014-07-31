Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaGaV17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:27:59 -0400
Received: from mail-pa0-f68.google.com ([209.85.220.68]:52764 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaGaV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:26:44 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>, heiko@sntech.de
Cc: dianders@chromium.org, olof@lixom.net, sonnyrao@chromium.org,
        addy.ke@rock-chips.com, cf@rock-chips.com, xjq@rock-chips.com,
        wulf@rock-chips.com, lyz@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Porter <mporter@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [REPOST PATCH v3 1/5] Documentation: dt-bindings: add dt binding info for Rockchip dwc2
Date: Thu, 31 Jul 2014 14:26:21 -0700
Message-Id: <1406841985-15790-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406841985-15790-1-git-send-email-kever.yang@rock-chips.com>
References: <1406841985-15790-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add necessary dwc2 binding documentation for Rockchip socs:
rk3066, rk3188 and rk3288

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
---

Changes in v3: None
Changes in v2:
- Split out dr_mode and rk3288 bindings.
- add compatible "snps,dwc2" bingding info

 Documentation/devicetree/bindings/usb/dwc2.txt |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc2.txt b/Documentation/devicetree/bindings/usb/dwc2.txt
index 467ddd1..2899679 100644
--- a/Documentation/devicetree/bindings/usb/dwc2.txt
+++ b/Documentation/devicetree/bindings/usb/dwc2.txt
@@ -4,6 +4,9 @@ Platform DesignWare HS OTG USB 2.0 controller
 Required properties:
 - compatible : One of:
   - brcm,bcm2835-usb: The DWC2 USB controller instance in the BCM2835 SoC.
+  - rockchip,rk3066-usb: The DWC2 USB controller instance in the rk3066 Soc;
+  - "rockchip,rk3188-usb", "rockchip,rk3066-usb", "snps,dwc2": for rk3188 Soc;
+  - "rockchip,rk3288-usb", "rockchip,rk3066-usb", "snps,dwc2": for rk3288 Soc;
   - snps,dwc2: A generic DWC2 USB controller with default parameters.
 - reg : Should contain 1 register range (address and length)
 - interrupts : Should contain 1 interrupt
-- 
1.7.9.5

