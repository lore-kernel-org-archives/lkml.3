Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaFKMev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:34:51 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:63032 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbaFKMep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:34:45 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de, grant.likely@linaro.org,
        matthias.bgg@gmail.com, thierry.reding@gmail.com,
        florian.vaussard@epfl.ch, jic23@kernel.org, jason@lakedaemon.net,
        andrew@lunn.ch, silvio.fricke@gmail.com, heiko.stuebner@bq.com,
        olof@lixom.net, sebastian.hesselbarth@gmail.com, sboyd@codeaurora.org,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        shawn.guo@freescale.com, anders.berg@lsi.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v8 6/7] dt-bindings: add documentation for Mediatek SoC
Date: Wed, 11 Jun 2014 14:34:14 +0200
Message-Id: <1402490055-15197-7-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402490055-15197-1-git-send-email-matthias.bgg@gmail.com>
References: <1402490055-15197-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a DT binding documentation for the MT6589 SoC from Mediatek.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/arm/mediatek.txt |    8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek.txt

diff --git a/Documentation/devicetree/bindings/arm/mediatek.txt b/Documentation/devicetree/bindings/arm/mediatek.txt
new file mode 100644
index 0000000..d6ac71f
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek.txt
@@ -0,0 +1,8 @@
+Mediatek MT6589 Platforms Device Tree Bindings
+
+Boards with a SoC of the Mediatek MT6589 shall have the following property:
+
+Required root node property:
+
+compatible: must contain "mediatek,mt6589"
+
-- 
1.7.9.5

