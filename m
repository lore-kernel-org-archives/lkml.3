Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaJUJJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:09:42 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50050 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaJUJIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:08:09 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] phy: berlin-sata: Document BG2 compatible
Date: Tue, 21 Oct 2014 11:07:55 +0200
Message-Id: <1413882477-27922-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413882477-27922-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413882477-27922-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Berlin BG2 SATA PHY is slightly different from currently supported
BG2Q SATA PHY. Document the new compatible for BG2's PHY.

Acked-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Kishon Vijay Abraham I <kishon@ti.com> 
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org 
---
 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
index 88f8c23384c0..c0155f842f62 100644
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
2.1.1

