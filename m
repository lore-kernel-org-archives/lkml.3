Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaKKRiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:38:46 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57194 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaKKRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:38:43 -0500
From: Johan Hovold <johan@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 01/22] dt/bindings: fix documentation of ethernet-phy compatible property
Date: Tue, 11 Nov 2014 18:37:19 +0100
Message-Id: <1415727460-20417-2-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415727460-20417-1-git-send-email-johan@kernel.org>
References: <1415727460-20417-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent commit extended the documentation of the ethernet-phy
compatible property, but placed the new paragraph under the max-speed
property.

Fixes: f00e756ed12d ("dt: Document a compatible entry for MDIO ethernet
Phys")

Cc: devicetree@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 Documentation/devicetree/bindings/net/phy.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
index 5b8c58903077..40831fbaff72 100644
--- a/Documentation/devicetree/bindings/net/phy.txt
+++ b/Documentation/devicetree/bindings/net/phy.txt
@@ -19,7 +19,6 @@ Optional Properties:
   specifications. If neither of these are specified, the default is to
   assume clause 22. The compatible list may also contain other
   elements.
-- max-speed: Maximum PHY supported speed (10, 100, 1000...)
 
   If the phy's identifier is known then the list may contain an entry
   of the form: "ethernet-phy-idAAAA.BBBB" where
@@ -29,6 +28,8 @@ Optional Properties:
             4 hex digits. This is the chip vendor OUI bits 19:24,
             followed by 10 bits of a vendor specific ID.
 
+- max-speed: Maximum PHY supported speed (10, 100, 1000...)
+
 Example:
 
 ethernet-phy@0 {
-- 
2.0.4

