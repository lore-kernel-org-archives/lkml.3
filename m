Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaJ0Q0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:26:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40910 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaJ0QX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:23:56 -0400
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: devicetree@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, robh@kernel.org,
        mark.rutland@arm.com, johan@kernel.org, linux-pm@vger.kernel.org,
        linux@roeck-us.net, lee.jones@linaro.org, balbi@ti.com,
        robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: [PATCH v1 05/10] dt-bindings: act8865: Update documentation about property system-power-controller
Date: Mon, 27 Oct 2014 16:26:50 +0000
Message-Id: <1414427215-14380-5-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 Documentation/devicetree/bindings/regulator/act8865-regulator.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
index 01a5b07..45369d8 100644
--- a/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/act8865-regulator.txt
@@ -6,8 +6,8 @@ Required properties:
 - reg: I2C slave address
 
 Optional properties:
-- poweroff-source: Telling whether or not this pmic is controlling
-  the system power. See Documentation/devicetree/bindings/power/poweroff.txt .
+- system-power-controller: Telling whether or not this pmic is controlling the
+  system power. See Documentation/devicetree/bindings/power/power-controller.txt.
 
 Any standard regulator properties can be used to configure the single regulator.
 
-- 
1.9.1

