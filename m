Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3LDJUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:20:44 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35607 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3LDJUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:20:40 -0500
From: dt.tangr@gmail.com
To: linux-usb@vger.kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: [PATCH 2/2] arm: nspire: modify device tree to use the nspire-usb driver
Date: Wed,  4 Dec 2013 20:20:08 +1100
Message-Id: <1386148808-15065-2-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com>
References: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>

This patch adds the needed compatible key to the device tree for TI-Nspires.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 arch/arm/boot/dts/nspire.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nspire.dtsi b/arch/arm/boot/dts/nspire.dtsi
index a22ffe6..baf7153 100644
--- a/arch/arm/boot/dts/nspire.dtsi
+++ b/arch/arm/boot/dts/nspire.dtsi
@@ -65,6 +65,7 @@
 		};
 
 		usb0: usb@B0000000 {
+			compatible = "lsi,nspire-usb";
 			reg = <0xB0000000 0x1000>;
 			interrupts = <8>;
 		};
-- 
1.7.10.4

