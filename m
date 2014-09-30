Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaI3R14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:27:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47598 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaI3R1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:27:04 -0400
From: Romain Perier <romain.perier@gmail.com>
To: devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        heiko@sntech.de
Subject: [RFC][PATCH 4/4] dt-bindings: Document the property poweroff-source for act8865 regulator
Date: Tue, 30 Sep 2014 17:29:46 +0000
Message-Id: <1412098186-5042-4-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412098186-5042-1-git-send-email-romain.perier@gmail.com>
References: <1412098186-5042-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 Documentation/devicetree/bindings/regulator/act8865-regulator.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
index 865614b..4d7f33e 100644
--- a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
@@ -5,6 +5,10 @@ Required properties:
 - compatible: "active-semi,act8846" or "active-semi,act8865"
 - reg: I2C slave address
 
+Optional properties:
+- poweroff-source: Telling whether or not this pmic is controlling
+  the system power
+
 Any standard regulator properties can be used to configure the single regulator.
 
 The valid names for regulators are:
-- 
1.9.1

