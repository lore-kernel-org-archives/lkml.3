Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab3EDLLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 07:11:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49009 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab3EDLLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 07:11:20 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-input@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <grant.likely@secretlab.ca>, <dmitry.torokhov@gmail.com>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <manishv.b@ti.com>
Subject: [PATCH V2 2/2] ARM: davinci: da850: add tps6507x touchscreen DT data
Date: Sat, 4 May 2013 16:42:31 +0530
Message-ID: <1367665951-29848-3-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367665951-29848-1-git-send-email-manishv.b@ti.com>
References: <1367665951-29848-1-git-send-email-manishv.b@ti.com>
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
Changes since V1:
	- Updated commit message.

:100644 100644 c914357... 9c136d1... M	arch/arm/boot/dts/da850-evm.dts
 arch/arm/boot/dts/da850-evm.dts |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c914357..9c136d1 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -155,4 +155,13 @@
 			regulator-boot-on;
 		};
 	};
+
+	tsc {
+		ti,poll_period = <30>;
+		ti,min_pressure = <0x30>;
+		ti,vref = <0>;
+		ti,vendor = <0>;
+		ti,product = <65070>;
+		ti,version = <0x100>;
+	};
 };
-- 
1.7.4.1

