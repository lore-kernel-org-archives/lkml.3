Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaGUVLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:11:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55501 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaGUVJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:09:37 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Gregory Fong <gregory.0xf0@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v8 06/11] ARM: brcmstb: add CPU binding for Broadcom Brahma15
Date: Mon, 21 Jul 2014 14:08:01 -0700
Message-Id: <1405976886-27807-7-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Carino <marc.ceeeee@gmail.com>

Add the Broadcom Brahma B15 CPU to the DT CPU binding list.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 Documentation/devicetree/bindings/arm/cpus.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 1fe72a0778cd..06fd7bba830c 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -163,6 +163,7 @@ nodes to be present and contain the properties described below.
 			    "arm,cortex-r4"
 			    "arm,cortex-r5"
 			    "arm,cortex-r7"
+			    "brcm,brahma-b15"
 			    "faraday,fa526"
 			    "intel,sa110"
 			    "intel,sa1100"
@@ -184,6 +185,7 @@ nodes to be present and contain the properties described below.
 			  can be one of:
 			    "allwinner,sun6i-a31"
 			    "arm,psci"
+			    "brcm,brahma-b15"
 			    "marvell,armada-375-smp"
 			    "marvell,armada-380-smp"
 			    "marvell,armada-xp-smp"
-- 
1.9.1

