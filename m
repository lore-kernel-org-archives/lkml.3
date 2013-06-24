Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3FXJwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:52:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61254 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3FXJwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:52:00 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, rob@landley.net, broonie@kernel.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] of/documentation: Update s5m8767-regulator bindings document
Date: Mon, 24 Jun 2013 15:06:57 +0530
Message-Id: <1372066617-23518-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s5m8767 regulator is used on Exynos platforms which use pin controller
to configure GPIOs. Update the example accordingly.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 .../bindings/regulator/s5m8767-regulator.txt       |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
index a35ff99..7364f71 100644
--- a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
@@ -103,13 +103,13 @@ Example:
 
 		s5m8767,pmic-buck-default-dvs-idx = <0>;
 
-		s5m8767,pmic-buck-dvs-gpios = <&gpx0 0 1 0 0>, /* DVS1 */
-						 <&gpx0 1 1 0 0>, /* DVS2 */
-						 <&gpx0 2 1 0 0>; /* DVS3 */
+		s5m8767,pmic-buck-dvs-gpios = <&gpx0 0 0>, /* DVS1 */
+						 <&gpx0 1 0>, /* DVS2 */
+						 <&gpx0 2 0>; /* DVS3 */
 
-		s5m8767,pmic-buck-ds-gpios = <&gpx2 3 1 0 0>, /* SET1 */
-						<&gpx2 4 1 0 0>, /* SET2 */
-						<&gpx2 5 1 0 0>; /* SET3 */
+		s5m8767,pmic-buck-ds-gpios = <&gpx2 3 0>, /* SET1 */
+						<&gpx2 4 0>, /* SET2 */
+						<&gpx2 5 0>; /* SET3 */
 
 		s5m8767,pmic-buck2-dvs-voltage = <1350000>, <1300000>,
 						 <1250000>, <1200000>,
-- 
1.7.9.5

