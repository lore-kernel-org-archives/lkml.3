Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3G2McK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:32:10 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:55117 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab3G2McG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:32:06 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ARM: dove: add MBUS_ID macro to Dove DT
Date: Mon, 29 Jul 2013 14:31:51 +0200
Message-Id: <1375101114-28858-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a macro used for defining address window's target ID and
attribute cells for the MBus ranges entry.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 90257c7..397674c 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -1,5 +1,7 @@
 /include/ "skeleton.dtsi"
 
+#define MBUS_ID(target,attributes) (((target) << 24) | ((attributes) << 16))
+
 / {
 	compatible = "marvell,dove";
 	model = "Marvell Armada 88AP510 SoC";
-- 
1.7.10.4

