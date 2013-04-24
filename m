Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3DXSQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:16:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39271 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab3DXSQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:16:57 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 1/2] staging: ti-soc-thermal: update DT reference for OMAP5430
Date: Wed, 24 Apr 2013 14:16:07 -0400
Message-ID: <1366827368-14316-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366827368-14316-1-git-send-email-eduardo.valentin@ti.com>
References: <1366827368-14316-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing irq line for TALERT on DT entry for OMAP5430.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/ti-soc-thermal/ti_soc_thermal.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ti-soc-thermal/ti_soc_thermal.txt b/drivers/staging/ti-soc-thermal/ti_soc_thermal.txt
index a4a33d1..1629652 100644
--- a/drivers/staging/ti-soc-thermal/ti_soc_thermal.txt
+++ b/drivers/staging/ti-soc-thermal/ti_soc_thermal.txt
@@ -57,4 +57,5 @@ bandgap {
 		0x4a002380 0x2c
 		0x4a0023C0 0x3c>;
 	compatible = "ti,omap5430-bandgap";
+	interrupts = <0 126 4>; /* talert */
 };
-- 
1.8.2.1.342.gfa7285d

