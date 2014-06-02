Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaFBJWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:22:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38036 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753159AbaFBJVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:21:10 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] Documentation: bindings: add the Berlin CPU control doc
Date: Mon,  2 Jun 2014 11:21:04 +0200
Message-Id: <1401700866-24804-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the CPU control compatible, needed for the SMP support on
Marvell Berlin SoCs.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 Documentation/devicetree/bindings/arm/marvell,berlin.txt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
index 0677003e1476..7f9b3ccdf25b 100644
--- a/Documentation/devicetree/bindings/arm/marvell,berlin.txt
+++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
@@ -23,3 +23,19 @@ SoC and board used. Currently known SoC compatibles are:
 
 	...
 }
+
+* Marvell Berlin CPU control bindings
+
+CPU control register allows various operations on CPUs, like resetting them
+independently.
+
+Required properties:
+- compatible: should be "marvell,berlin-cpu-ctrl"
+- reg: address and length of the register set
+
+Example:
+
+cpu-ctrl@f7dd0000 {
+	compatible = "marvell,berlin-cpu-ctrl";
+	reg = <0xf7dd0000 0x10000>;
+};
-- 
1.9.1

