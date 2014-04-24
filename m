Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbaDXRNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:13:07 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58926 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbaDXRND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:13:03 -0400
From: Matt Porter <mporter@linaro.org>
To: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] dt: bindings: dwc2: fix required value for the phy-names property
Date: Thu, 24 Apr 2014 13:12:56 -0400
Message-Id: <1398359576-14668-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"7408484 usb: gadget: s3c-hsotg: enable generic phy support" introduces
generic phy support to the dwc2.txt binding and the s3c-hsotg driver
which implements support for the binding. The binding documentation
incorrectly states that the phy-names property will be "device". The
binding example, driver, and one dts user all implement the phy-names
property as requiring "usb2-phy".

Fix the dwc2.txt binding documentation to correctly specify "usb2-phy"
as the appropriate value for phy-names.

Reported-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Matt Porter <mporter@linaro.org>
---
 Documentation/devicetree/bindings/usb/dwc2.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/dwc2.txt b/Documentation/devicetree/bindings/usb/dwc2.txt
index b8b6871..467ddd1 100644
--- a/Documentation/devicetree/bindings/usb/dwc2.txt
+++ b/Documentation/devicetree/bindings/usb/dwc2.txt
@@ -13,7 +13,7 @@ Refer to clk/clock-bindings.txt for generic clock consumer properties
 
 Optional properties:
 - phys: phy provider specifier
-- phy-names: shall be "device"
+- phy-names: shall be "usb2-phy"
 Refer to phy/phy-bindings.txt for generic phy consumer properties
 
 Example:
-- 
1.8.4

