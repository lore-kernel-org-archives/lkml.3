Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3J1GN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:13:59 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64270 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3J1GN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:13:58 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: yadi.brar@samsung.com, lee.jones@linaro.org
Subject: [PATCH] Documentation: mfd: Fix typo in s2mps11.txt
Date: Mon, 28 Oct 2013 11:42:41 +0530
Message-Id: <1382940761-30471-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Numbers in DT scripts should be within angle brackets.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index c9332c6..b886b07f 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -71,7 +71,7 @@ Example:
 		reg = <0x66>;
 
 		s2m_osc: clocks{
-			#clock-cells = 1;
+			#clock-cells = <1>;
 			clock-output-names = "xx", "yy", "zz";
 		};
 
-- 
1.7.9.5

