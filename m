Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3JWQ3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:29:11 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54449 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3JWQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:29:06 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-input@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Cc: grant.likely@secretlab.ca, dmitry.torokhov@gmail.com,
        rob.herring@calxeda.com, rob@landley.net, badarkhe.manish@gmail.com
Subject: [PATCH V4 2/2] ARM: davinci: da850: add tps6507x touchscreen DT data
Date: Wed, 23 Oct 2013 21:58:53 +0530
Message-Id: <1382545733-8865-3-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382545733-8865-1-git-send-email-badarkhe.manish@gmail.com>
References: <1382545733-8865-1-git-send-email-badarkhe.manish@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tps6507x touchscreen DT node to da850-evm.
Touchscreen DT data is added as per da850 board file.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
Changes since V3:
 - Removed vref property.

Changes since V2:
 - Updated tps6507x documentation.
 - Removed unnecessary code.

Changes since V1:
 - Updated tps6507x documentation.
 - Updated commit message.
 - return proper error value in absence platform and DT data
   for touchscreen.

:100644 100644 588ce58... 5a35264... M	arch/arm/boot/dts/da850-evm.dts
 arch/arm/boot/dts/da850-evm.dts |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 588ce58..5a35264 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -166,4 +166,12 @@
 			regulator-boot-on;
 		};
 	};
+
+	tsc {
+		ti,poll-period = <30>;
+		ti,min-pressure = <0x30>;
+		ti,vendor = <0>;
+		ti,product = <65070>;
+		ti,version = <0x100>;
+	};
 };
-- 
1.7.10.4

