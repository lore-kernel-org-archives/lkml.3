Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaIBQOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:14:53 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59853 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaIBQOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:14:50 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Chris Zhong <zyw@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        zhangqing@rock-chips.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dt-bindings: Add input supplies to rk808 bindings
Date: Tue,  2 Sep 2014 09:14:29 -0700
Message-Id: <1409674469-12123-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409674469-12123-1-git-send-email-dianders@chromium.org>
References: <1409674469-12123-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original bindings for rk808 didn't include input supplies.  Add
them.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 Documentation/devicetree/bindings/mfd/rk808.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
index f8932ac..283a906 100644
--- a/Documentation/devicetree/bindings/mfd/rk808.txt
+++ b/Documentation/devicetree/bindings/mfd/rk808.txt
@@ -13,6 +13,17 @@ Optional properties:
   default output clock name
 - rockchip,system-power-controller: Telling whether or not this pmic is controlling
   the system power.
+- vcc1-supply:  The input supply for DCDC_REG1
+- vcc2-supply:  The input supply for DCDC_REG2
+- vcc3-supply:  The input supply for DCDC_REG3
+- vcc4-supply:  The input supply for DCDC_REG4
+- vcc6-supply:  The input supply for LDO_REG1 and LDO_REG2
+- vcc7-supply:  The input supply for LDO_REG3 and LDO_REG7
+- vcc8-supply:  The input supply for SWITCH_REG1
+- vcc9-supply:  The input supply for LDO_REG4 and LDO_REG5
+- vcc10-supply: The input supply for LDO_REG6
+- vcc11-supply: The input supply for LDO_REG8
+- vcc12-supply: The input supply for SWITCH_REG2
 
 Regulators: All the regulators of RK808 to be instantiated shall be
 listed in a child node named 'regulators'. Each regulator is represented
-- 
2.1.0.rc2.206.gedb03e5

