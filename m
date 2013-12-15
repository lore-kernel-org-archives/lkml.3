Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3LOJyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 04:54:44 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53349 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3LOJyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 04:54:41 -0500
From: dt.tangr@gmail.com
To: linux-leds@vger.kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk
Subject: [PATCH 2/3] arm: nspire: modify device tree to use the LSI Zevio LED driver
Date: Sun, 15 Dec 2013 20:54:12 +1100
Message-Id: <1387101253-30804-2-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387101253-30804-1-git-send-email-dt.tangr@gmail.com>
References: <1387101253-30804-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>


Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 arch/arm/boot/dts/nspire.dtsi |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/nspire.dtsi b/arch/arm/boot/dts/nspire.dtsi
index a22ffe6..bb453bb 100644
--- a/arch/arm/boot/dts/nspire.dtsi
+++ b/arch/arm/boot/dts/nspire.dtsi
@@ -167,8 +167,9 @@
 				reg = <0x900F0000 0x1000>;
 			};
 
-			led: led@90110000 {
-				reg = <0x90110000 0x1000>;
+			led: led@90110B00 {
+				compatible = "lsi,zevio-led";
+				reg = <0x90110B00 0x100>;
 			};
 		};
 	};
-- 
1.7.10.4

