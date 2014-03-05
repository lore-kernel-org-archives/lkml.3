Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaCEJPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:15:41 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51456 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaCEJPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:15:38 -0500
From: dt.tangr@gmail.com
To: linux-arm-kernel@lists.infradead.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        robh+dt@kernel.org, Peter.Chen@freescale.com
Subject: [PATCH RESEND] arm: nspire: modify device tree to use the lsi,zevio-usb driver
Date: Wed,  5 Mar 2014 20:15:16 +1100
Message-Id: <1394010916-17375-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
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

