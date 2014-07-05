Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaGENXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 09:23:04 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37118 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaGENWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 09:22:45 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>,
        Axel Lin <axel.lin@ingics.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 4/4] regulator: act8865: add act8846 to DT binding documentation
Date: Sat,  5 Jul 2014 15:20:56 +0200
Message-Id: <1404566456-9121-5-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404566456-9121-1-git-send-email-b.galvani@gmail.com>
References: <1404566456-9121-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new "active-semi,act8846" compatible string and a
list of supported regulator names to the devicetree binding
documentation for Active-Semi PMUs.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 .../devicetree/bindings/regulator/act8865-regulator.txt         |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
index bef1fbb..865614b 100644
--- a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
@@ -1,13 +1,16 @@
-ACT8865 regulator
+ACT88xx regulators
 -------------------
 
 Required properties:
-- compatible: "active-semi,act8865"
+- compatible: "active-semi,act8846" or "active-semi,act8865"
 - reg: I2C slave address
 
 Any standard regulator properties can be used to configure the single regulator.
 
 The valid names for regulators are:
+	- for act8846:
+	REG1, REG2, REG3, REG4, REG5, REG6, REG7, REG8, REG9, REG10, REG11, REG12
+	- for act8865:
 	DCDC_REG1, DCDC_REG2, DCDC_REG3, LDO_REG1, LDO_REG2, LDO_REG3, LDO_REG4.
 
 Example:
-- 
1.7.10.4

