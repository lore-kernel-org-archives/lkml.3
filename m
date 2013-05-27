Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3E0Oil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:38:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38446 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab3E0Ohs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:37:48 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v2 12/14] Documentation: dt: binding: omap: am43x counter
Date: Mon, 27 May 2013 20:07:14 +0530
Message-ID: <755964dc45ae4f023540c05e5739fca87d0ea70b.1369658705.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1369658705.git.afzal@ti.com>
References: <cover.1369658705.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM43x 32K counter binding.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 Documentation/devicetree/bindings/arm/omap/counter.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/omap/counter.txt b/Documentation/devicetree/bindings/arm/omap/counter.txt
index 5bd8aa0..9c48dca 100644
--- a/Documentation/devicetree/bindings/arm/omap/counter.txt
+++ b/Documentation/devicetree/bindings/arm/omap/counter.txt
@@ -2,6 +2,7 @@ OMAP Counter-32K bindings
 
 Required properties:
 - compatible:	Must be "ti,omap-counter32k" for OMAP controllers
+		"ti,am4372-counter32k","ti,omap-counter32k" for AM43x counter
 - reg:		Contains timer register address range (base address and length)
 - ti,hwmods:	Name of the hwmod associated to the counter, which is typically
 		"counter_32k"
-- 
1.7.12

