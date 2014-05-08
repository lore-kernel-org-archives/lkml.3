Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaEHHkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:40:52 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:37873 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaEHHkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:40:49 -0400
From: Johan Hovold <jhovold@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Mugunthan V N <mugunthanvnm@ti.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/5] net: mdio-gpio: fix device-tree binding documentation
Date: Thu,  8 May 2014 09:37:15 +0200
Message-Id: <1399534639-4947-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399534639-4947-1-git-send-email-jhovold@gmail.com>
References: <1399534639-4947-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix aliases syntax in device-tree binding example to avoid
copy-paste errors (the alias would be dropped silently).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 Documentation/devicetree/bindings/net/mdio-gpio.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
index c79bab025369..8dbcf8295c6c 100644
--- a/Documentation/devicetree/bindings/net/mdio-gpio.txt
+++ b/Documentation/devicetree/bindings/net/mdio-gpio.txt
@@ -14,7 +14,7 @@ node.
 Example:
 
 aliases {
-	mdio-gpio0 = <&mdio0>;
+	mdio-gpio0 = &mdio0;
 };
 
 mdio0: mdio {
-- 
1.8.3.2

