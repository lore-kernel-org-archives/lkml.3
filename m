Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3F1Qod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:44:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:32896 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3F1Qob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:44:31 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, lorenzo.pieralisi@arm.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/2] sunxi: a10s: dtsi: Convert cpu node to the new cpu bindings
Date: Fri, 28 Jun 2013 18:44:04 +0200
Message-Id: <1372437844-16325-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A10s DTSI was merged without the newer cpu bindings, leading to a
warning being displayed at boot time.

Convert the A10s DTSI to these new bindings, and thus remove the
warning.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a10s.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index 2307ce8..55c086e 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -18,7 +18,9 @@
 
 	cpus {
 		cpu@0 {
+			device_type = "cpu";
 			compatible = "arm,cortex-a8";
+			reg = <0x0>;
 		};
 	};
 
-- 
1.8.3.1

