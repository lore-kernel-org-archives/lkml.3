Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaGGGtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:49:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50431 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbaGGGsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:48:53 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] phy: core: Add phy-supply to DT binding documentation
Date: Mon, 7 Jul 2014 12:18:24 +0530
Message-ID: <1404715705-5041-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404715705-5041-1-git-send-email-kishon@ti.com>
References: <1404715705-5041-1-git-send-email-kishon@ti.com>
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

