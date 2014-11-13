Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbaKMLss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:48:48 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39260 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932672AbaKMLsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:48:16 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: "Kishon Vijay Abraham I" <kishon@ti.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/7] MAINTAINERS: add entry for the Armada 375 USB cluster PHY driver
Date: Thu, 13 Nov 2014 12:47:49 +0100
Message-Id: <1415879269-29711-8-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415879269-29711-1-git-send-email-gregory.clement@free-electrons.com>
References: <1415879269-29711-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS add entry for the Armada 375 USB cluster PHY driver.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea4d0058fd1b..ea35fa243502 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1571,6 +1571,12 @@ S:	Maintained
 F:	arch/arm64/
 F:	Documentation/arm64/
 
+ARMADA 375 USB PHY DRIVER
+M:	Gregory Clement <gregory.clement@free-electrons.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/phy/phy-armada375-usb2.c
+
 AS3645A LED FLASH CONTROLLER DRIVER
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
1.9.1

