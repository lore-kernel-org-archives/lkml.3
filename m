Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaJEWBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 18:01:35 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50727 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaJEWBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 18:01:20 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 5/7] ARM: document Tronsmart compatible properties
Date: Sun,  5 Oct 2014 23:59:17 +0200
Message-Id: <1412546359-15062-6-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412546359-15062-1-git-send-email-b.galvani@gmail.com>
References: <1412546359-15062-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document device tree bindings for Tronsmart devices.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 Documentation/devicetree/bindings/arm/tronsmart.txt | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/tronsmart.txt

diff --git a/Documentation/devicetree/bindings/arm/tronsmart.txt b/Documentation/devicetree/bindings/arm/tronsmart.txt
new file mode 100644
index 0000000..bd29d60
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/tronsmart.txt
@@ -0,0 +1,7 @@
+Tronsmart Platforms Device Tree Bindings
+---------------------------------------
+
+Vega S89 Elite TV box
+
+Required root node properties:
+    - compatible = "tronsmart,vega-s89e";
-- 
1.9.1

