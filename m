Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3EUIwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:52:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40225 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab3EUIwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:52:36 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-input@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <grant.likely@secretlab.ca>, <dmitry.torokhov@gmail.com>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <manishv.b@ti.com>
Subject: [PATCH V3 2/2] ARM: davinci: da850: add tps6507x touchscreen DT data
Date: Tue, 21 May 2013 14:24:18 +0530
Message-ID: <1369126458-24872-3-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369126458-24872-1-git-send-email-manishv.b@ti.com>
References: <1369126458-24872-1-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tps6507x touchscreen DT node to da850-evm.
Touchscreen DT data is added as per da850 board file.

Tested on da850-evm.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
Changes since V2:
 - Updated names of devicetree properties.
Changes since V1:
 - Updated commit message.

:100644 100644 c914357... 1ca1691... M	arch/arm/boot/dts/da850-evm.dts
 arch/arm/boot/dts/da850-evm.dts |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c914357..1ca1691 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -155,4 +155,13 @@
 			regulator-boot-on;
 		};
 	};
+
+	tsc {
+		ti,poll-period = <30>;
+		ti,min-pressure = <0x30>;
+		ti,vref = <0>;
+		ti,vendor = <0>;
+		ti,product = <65070>;
+		ti,version = <0x100>;
+	};
 };
-- 
1.7.4.1

