Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaC1QK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:10:58 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60216 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaC1QIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:08:16 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, benh@kernel.crashing.org,
        rob.herring@linaro.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [RFC 4/5] arm/versatile: Add the uart as the stdout device.
Date: Fri, 28 Mar 2014 09:08:04 -0700
Message-Id: <1396022885-6102-5-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.8.3.2

