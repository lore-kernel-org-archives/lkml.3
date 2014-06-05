Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaFET2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:28:10 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37768 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbaFET2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:28:03 -0400
X-Sasl-enc: erSiHh+lgHxV2opu94Sbby5rR/sHSlefEknY9vgx+QmI 1401996478
From: Andrew Ruder <andrew.ruder@elecsyscorp.com>
To: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        rdunlap@infradead.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org,
        Andrew Ruder <andrew.ruder@elecsyscorp.com>
Subject: [PATCH 2/6] pxa-usb: devicetree bindings docs update
Date: Thu,  5 Jun 2014 14:27:04 -0500
Message-Id: <dde06a6340907cf0fea368d68966ea39cfd4d6e3.1401995177.git.andrew.ruder@elecsyscorp.com>
X-Mailer: git-send-email 1.9.0.rc3.12.gbc97e2d
In-Reply-To: <cover.1401995177.git.andrew.ruder@elecsyscorp.com>
References: <cover.1401995177.git.andrew.ruder@elecsyscorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few tags documented in pxa-usb.txt don't match the code and one isn't
documented at all.  Updating documentation to match the code.

    marvell,power-sense-low -> marvell,port-sense-low
    marvell,power_on_delay  -> marvell,power-on-delay
    marvell,power-budget (new to documentation)

Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>
---
 Documentation/devicetree/bindings/usb/pxa-usb.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/pxa-usb.txt b/Documentation/devicetree/bindings/usb/pxa-usb.txt
index 79729a9..13ab5b0 100644
--- a/Documentation/devicetree/bindings/usb/pxa-usb.txt
+++ b/Documentation/devicetree/bindings/usb/pxa-usb.txt
@@ -13,11 +13,12 @@ Optional properties:
 	1 = PMM_NPS_MODE
 	2 = PMM_GLOBAL_MODE
 	3 = PMM_PERPORT_MODE
- - "marvell,power-sense-low" - power sense pin is low-active.
+ - "marvell,port-sense-low" - power sense pin is low-active.
  - "marvell,power-control-low" - power control pin is low-active.
  - "marvell,no-oc-protection" - disable over-current protection.
  - "marvell,oc-mode-perport" - enable per-port over-current protection.
- - "marvell,power_on_delay" Power On to Power Good time - in ms.
+ - "marvell,power-on-delay" - Power On to Power Good time - in ms.
+ - "marvell,power-budget" - Power budget in mA (0 is no limit)
 
 Example:
 
-- 
1.9.0.rc3.12.gbc97e2d

