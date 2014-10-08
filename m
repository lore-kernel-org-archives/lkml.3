Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbaJHAH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:07:28 -0400
Received: from exprod5og123.obsmtp.com ([64.18.0.198]:42199 "HELO
	exprod5og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755539AbaJHAGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:06:54 -0400
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, jassisingbrar@gmail.com, =devicetree@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>, Hieu Le <hnle@apm.com>
Subject: [PATCH 6/6] arm64: dts: add proxy I2C device driver on APM X-Gene platform
Date: Tue,  7 Oct 2014 17:06:49 -0700
Message-Id: <1412726809-7525-7-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412726809-7525-1-git-send-email-fkan@apm.com>
References: <1412726809-7525-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add proxy I2C device driver on APM X-Gene platform.

Signed-off-by: Feng Kan <fkan@apm.com>
Signed-off-by: Hieu Le <hnle@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 249f025..09daf4c 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -469,6 +469,12 @@
 					<0x0 0x7 0x4>;
 		};
 
+		i2cslimpro {
+			compatible = "apm,xgene-slimpro-i2c";
+			mbox = <&mailbox 0>;
+			mbox-names = "i2c-slimpro";
+		};
+
 		serial0: serial@1c020000 {
 			status = "disabled";
 			device_type = "serial";
-- 
1.9.1

