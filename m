Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3FJKXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:23:41 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54418 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3FJKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:23:38 -0400
Date: Mon, 10 Jun 2013 11:23:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [PATCH 7/7 v2] Documentation: Update binding for Nomadik and DBx5x
 based platforms
Message-ID: <20130610102333.GJ20297@gmail.com>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
 <1369232581-18923-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369232581-18923-8-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change compatible string to something more standard.
   
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
index 9a2f3f4..6b33b9f 100644
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
+		compatible = "stericsson,db8500-pinctrl";
 		reg = <0x80157000 0x2000>;
 
 		pinctrl-names = "default";
