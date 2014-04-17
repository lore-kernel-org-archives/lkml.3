Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaDQRn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:43:27 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:60774 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaDQRnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:43:13 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/3] arm: dts: add device_type="memory" for ste-ccu8540
Date: Thu, 17 Apr 2014 18:41:59 +0100
Message-Id: <1397756521-29387-2-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current .dts for ste-ccu8540 lacks a 'device_type = "memory"' for
its memory node, relying on an old ppc quirk in order to discover its
memory. Add this, to permit that quirk to be made ppc only.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ste-ccu8540.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/ste-ccu8540.dts b/arch/arm/boot/dts/ste-ccu8540.dts
index 7f3baf5..32dd55e 100644
--- a/arch/arm/boot/dts/ste-ccu8540.dts
+++ b/arch/arm/boot/dts/ste-ccu8540.dts
@@ -18,6 +18,7 @@
 	compatible = "st-ericsson,ccu8540", "st-ericsson,u8540";
 
 	memory@0 {
+		device_type = "memory";
 		reg = <0x20000000 0x1f000000>, <0xc0000000 0x3f000000>;
 	};
 
-- 
1.7.10.4

