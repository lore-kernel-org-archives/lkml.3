Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaK0GbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:31:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59566 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbaK0G0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:36 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/25] phy: berlin-sata: Document BG2 compatible
Date: Thu, 27 Nov 2014 11:56:03 +0530
Message-ID: <1417069577-1169-12-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Berlin BG2 SATA PHY is slightly different from currently supported
BG2Q SATA PHY. Document the new compatible for BG2's PHY.

Acked-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
index 88f8c23..c0155f8 100644
--- a/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
+++ b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
@@ -2,7 +2,9 @@ Berlin SATA PHY
 ---------------
 
 Required properties:
-- compatible: should be "marvell,berlin2q-sata-phy"
+- compatible: should be one of
+    "marvell,berlin2-sata-phy"
+    "marvell,berlin2q-sata-phy"
 - address-cells: should be 1
 - size-cells: should be 0
 - phy-cells: from the generic PHY bindings, must be 1
-- 
1.7.9.5

