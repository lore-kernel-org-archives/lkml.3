Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaHDNv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:51:29 -0400
Received: from mail-pd0-f196.google.com ([209.85.192.196]:40805 "EHLO
	mail-pd0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaHDNv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:51:26 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: dianders@chromium.org, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@vger.kernel.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, olof@lixom.net,
        sonnyrao@chromium.org, wulf@rock-chips.com, lyz@rock-chips.com,
        jg1.han@samsung.com, hj@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Porter <mporter@linaro.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Felipe Balbi <balbi@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] Documentation: dt-bindings: add dt binding info for dwc2 dr_mode
Date: Mon,  4 Aug 2014 21:45:41 +0800
Message-Id: <1407159942-7063-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407159942-7063-1-git-send-email-kever.yang@rock-chips.com>
References: <1407159942-7063-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indicate that the generic dr_mode binding should be used for dwc2.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v3: None
Changes in v2:
- Split out dr_mode and rk3288 bindings.

 Documentation/devicetree/bindings/usb/dwc2.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/dwc2.txt b/Documentation/devicetree/bindings/usb/dwc2.txt
index 467ddd1..3cf92b6 100644
--- a/Documentation/devicetree/bindings/usb/dwc2.txt
+++ b/Documentation/devicetree/bindings/usb/dwc2.txt
@@ -15,6 +15,8 @@ Optional properties:
 - phys: phy provider specifier
 - phy-names: shall be "usb2-phy"
 Refer to phy/phy-bindings.txt for generic phy consumer properties
+- dr_mode: shall be one of "host", "peripheral" and "otg"
+  Refer to usb/generic.txt
 
 Example:
 
-- 
1.9.1

