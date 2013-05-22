Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab3EVObz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:31:55 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:38165 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3EVObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:31:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/7] Documentation: Update binding for Nomadik and DBx5x based platforms
Date: Wed, 22 May 2013 15:23:01 +0100
Message-Id: <1369232581-18923-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change compatible string to something more standard.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
index 9a2f3f4..c3d8a89 100644
--- a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
+++ b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
@@ -1,8 +1,8 @@
 ST Ericsson Nomadik pinmux controller
 
 Required properties:
-- compatible: "stericsson,nmk-pinctrl", "stericsson,nmk-pinctrl-db8540",
-              "stericsson,nmk-pinctrl-stn8815"
+- compatible: "stericsson,db8500-pinctrl", "stericsson,db8540-pinctrl",
+              "stericsson,stn8815-pinctrl"
 - reg: Should contain the register physical address and length of the PRCMU.
 
 Please refer to pinctrl-bindings.txt in this directory for details of the
@@ -68,7 +68,7 @@ Optional subnode-properties:
 Example board file extract:
 
 	pinctrl@80157000 {
-		compatible = "stericsson,nmk-pinctrl";
+		compatible = "stericsson,u8500-pinctrl";
 		reg = <0x80157000 0x2000>;
 
 		pinctrl-names = "default";
-- 
1.7.10.4

