Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaGVLBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:01:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46575 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbaGVK5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:30 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/28] phy: core: Add phy-supply to DT binding documentation
Date: Tue, 22 Jul 2014 16:26:36 +0530
Message-ID: <1406026611-30493-14-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

phy-supply is a phandle to the regulator that provides power to the
PHY. This regulator is managed during the PHY power on/off sequence
by the phy core driver.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/phy-bindings.txt       |    4 ++++
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
1.7.9.5

