Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaFQHkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:40:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44411 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755438AbaFQHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:39:10 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 7/7] mfd: AXP20x: add "x-powers,axp221" compatible string to DT bindings doc
Date: Tue, 17 Jun 2014 09:38:43 +0200
Message-Id: <1402990723-28138-8-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "x-powers,axp221" compatible string to the AXP20x DT bindings
documentation.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 Documentation/devicetree/bindings/mfd/axp20x.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/axp20x.txt b/Documentation/devicetree/bindings/mfd/axp20x.txt
index cc9e01b..f22a169 100644
--- a/Documentation/devicetree/bindings/mfd/axp20x.txt
+++ b/Documentation/devicetree/bindings/mfd/axp20x.txt
@@ -5,7 +5,7 @@ axp202 (X-Powers)
 axp209 (X-Powers)
 
 Required properties:
-- compatible: "x-powers,axp202" or "x-powers,axp209"
+- compatible: "x-powers,axp202", "x-powers,axp209" or "x-powers,axp221"
 - reg: The I2C slave address for the AXP chip
 - interrupt-parent: The parent interrupt controller
 - interrupts: Interrupt specifiers for interrupt sources
-- 
1.8.3.2

