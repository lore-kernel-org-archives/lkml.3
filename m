Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaFRUzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:55:49 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45815 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbaFRUzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:55:04 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org,
        olof@lixom.net, benh@kernel.crashing.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 3/4] arm/versatile: Add the uart as the stdout device.
Date: Wed, 18 Jun 2014 21:54:33 +0100
Message-Id: <1403124874-19929-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403124874-19929-1-git-send-email-grant.likely@linaro.org>
References: <1403124874-19929-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a stdout-path property to the Versatile devicetree so that automatic
console selection works without needing a console= line on the kernel
command line.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 arch/arm/boot/dts/versatile-ab.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
index e01e5a081def..88e94c5506a1 100644
--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -15,6 +15,10 @@
 		i2c0 = &i2c0;
 	};
 
+	chosen {
+		stdout-path = &uart0;
+	};
+
 	memory {
 		reg = <0x0 0x08000000>;
 	};
-- 
1.9.1

