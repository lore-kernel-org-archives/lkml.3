Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab3GDGeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:34:08 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47968 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3GDGeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:34:06 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] regulator: s5m8767: Fix a trivial typo in documentation
Date: Thu,  4 Jul 2013 11:48:38 +0530
Message-Id: <1372918719-20260-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed volatage to voltage.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 .../bindings/regulator/s5m8767-regulator.txt       |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
index 7364f71..d1660a9 100644
--- a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
@@ -1,6 +1,6 @@
 * Samsung S5M8767 Voltage and Current Regulator
 
-The Samsung S5M8767 is a multi-function device which includes volatage and
+The Samsung S5M8767 is a multi-function device which includes voltage and
 current regulators, rtc, charger controller and other sub-blocks. It is
 interfaced to the host controller using a i2c interface. Each sub-block is
 addressed by the host system using different i2c slave address. This document
-- 
1.7.9.5

