Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3LODfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 22:35:38 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44734 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3LODfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 22:35:33 -0500
From: dt.tangr@gmail.com
To: linux-usb@vger.kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk
Subject: [PATCH 2/3] arm: nspire: modify device tree to use the lsi,zevio-usb driver
Date: Sun, 15 Dec 2013 14:35:08 +1100
Message-Id: <1387078509-14156-2-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387078509-14156-1-git-send-email-dt.tangr@gmail.com>
References: <1387078509-14156-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>


Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 arch/arm/boot/dts/nspire.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nspire.dtsi b/arch/arm/boot/dts/nspire.dtsi
index a22ffe6..012c6d1 100644
--- a/arch/arm/boot/dts/nspire.dtsi
+++ b/arch/arm/boot/dts/nspire.dtsi
@@ -65,6 +65,7 @@
 		};
 
 		usb0: usb@B0000000 {
+			compatible = "lsi,zevio-usb";
 			reg = <0xB0000000 0x1000>;
 			interrupts = <8>;
 		};
-- 
1.7.10.4

