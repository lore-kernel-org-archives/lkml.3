Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3AKKn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:43:56 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46078 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3AKKnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:43:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: ux500: Include the PRCMU's Secure Registers in DB8500's DT
Date: Fri, 11 Jan 2013 10:43:49 +0000
Message-Id: <1357901029-9073-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we only include the PRCMU's primary registers when
referencing the register count in the 'reg' property. This patch
expands that count to include the secure registers also.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 2efd9c8..337c3b9 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -190,7 +190,7 @@
 
 		prcmu@80157000 {
 			compatible = "stericsson,db8500-prcmu";
-			reg = <0x80157000 0x1000>;
+			reg = <0x80157000 0x2000>;
 			interrupts = <0 47 0x4>;
 			#address-cells = <1>;
 			#size-cells = <1>;
-- 
1.7.9.5

