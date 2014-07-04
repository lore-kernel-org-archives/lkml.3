Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299AbaGDJ4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:56:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45682 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964984AbaGDJ4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:56:10 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <nsekhar@ti.com>, <nm@ti.com>, <george.cherian@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 4/6] phy: core: Add phy-supply to DT binding documentation
Date: Fri, 4 Jul 2014 12:55:46 +0300
Message-ID: <1404467748-12154-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404467748-12154-1-git-send-email-rogerq@ti.com>
References: <1404467748-12154-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

phy-supply is a phandle to the regulator that provides power to the
PHY. This regulator is managed during the PHY power on/off sequence
by the phy core driver.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/phy/phy-bindings.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
index 8ae844f..2aa1840 100644
--- a/Documentation/devicetree/bindings/phy/phy-bindings.txt
+++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
@@ -10,6 +10,10 @@ Required Properties:
 		provider can use the values in cells to find the appropriate
 		PHY.
 
+Optional Properties:
+phy-supply:	Phandle to a regulator that provides power to the PHY. This
+		regulator will be managed during the PHY power on/off sequence.
+
 For example:
 
 phys: phy {
-- 
1.8.3.2

