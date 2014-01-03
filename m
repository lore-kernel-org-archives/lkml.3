Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaACKDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 05:03:37 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62069 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaACKDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 05:03:35 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, mark.rutland@arm.com
Subject: [PATCH Resend] regulator: s5m8767: Update LDO index in s5m8767-regulator.txt
Date: Fri,  3 Jan 2014 15:29:49 +0530
Message-Id: <1388743189-6174-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LDO indices start from 1. Update the example accordingly.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 .../bindings/regulator/s5m8767-regulator.txt       |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
index d1660a90fc06..fc6b38f035bd 100644
--- a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
@@ -83,7 +83,7 @@ as per the datasheet of s5m8767.
 
 	- LDOn
 		  - valid values for n are 1 to 28
-		  - Example: LDO0, LD01, LDO28
+		  - Example: LDO1, LD02, LDO28
 	- BUCKn
 		  - valid values for n are 1 to 9.
 		  - Example: BUCK1, BUCK2, BUCK9
-- 
1.7.9.5

