Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964774AbaLMBrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 20:47:48 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52666 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966AbaLMBrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 20:47:05 -0500
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/3] ARM: tegra: dts: remove unused irq-trigger entry
Date: Sat, 13 Dec 2014 02:46:47 +0100
Message-Id: <bc18448982ba1fb8b976443193937a8bc6cc4c23.1418434448.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418434448.git.silvio.fricke@gmail.com>
References: <cover.1418434448.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1418434448.git.silvio.fricke@gmail.com>
References: <cover.1418434448.git.silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/boot/dts/tegra30-apalis.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi
index a5446cb..c2a7528 100644
--- a/arch/arm/boot/dts/tegra30-apalis.dtsi
+++ b/arch/arm/boot/dts/tegra30-apalis.dtsi
@@ -540,7 +540,6 @@
 			interrupt-controller;
 			id = <0>;
 			blocks = <0x5>;
-			irq-trigger = <0x1>;
 
 			stmpe_touchscreen {
 				compatible = "st,stmpe-ts";
-- 
2.1.3

