Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966892Ab3E2PIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:08:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48534 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966809Ab3E2PId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:08:33 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        J Keerthy <j-keerthy@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH 1/7] thermal: ti-soc-thermal: update DT reference for OMAP5430
Date: Wed, 29 May 2013 11:07:40 -0400
Message-ID: <1369840066-20357-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com>
References: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing irq line for TALERT on DT entry for OMAP5430.

Cc: linux-pm@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: J Keerthy <j-keerthy@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt | 1 +
 1 file changed, 1 insertion(+)
---
This patch was added to the staging tree post 3.10-rc1 but
is not included after the move from staging to thermal. This is
because the thermal tree is based of 3.10-rc1 and not staging/next
or linux-next/master.

For your reference:
https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/commit/drivers/staging/ti-soc-thermal?h=staging-next&id=faa4b9de12fa433f06be917feb3f13792b12fefa

diff --git a/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt b/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
index a4a33d1..1629652 100644
--- a/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
@@ -57,4 +57,5 @@ bandgap {
 		0x4a002380 0x2c
 		0x4a0023C0 0x3c>;
 	compatible = "ti,omap5430-bandgap";
+	interrupts = <0 126 4>; /* talert */
 };
-- 
1.8.2.1.342.gfa7285d

