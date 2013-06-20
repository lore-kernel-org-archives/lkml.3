Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391Ab3FTLGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:06:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60823 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965190Ab3FTLGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:06:33 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <grant.likely@secretlab.ca>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <gg@slimlogic.co.uk>
Subject: [PATCH 1/4] MFD: Add TPS659038 documentation under Palmas
Date: Thu, 20 Jun 2013 16:34:49 +0530
Message-ID: <1371726289-10042-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TPS659038 documentation under Palmas.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 Documentation/devicetree/bindings/mfd/palmas.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
index 7bcd59c..89cb773 100644
--- a/Documentation/devicetree/bindings/mfd/palmas.txt
+++ b/Documentation/devicetree/bindings/mfd/palmas.txt
@@ -5,6 +5,7 @@ twl6035 (palmas)
 twl6037 (palmas)
 tps65913 (palmas)
 tps65914 (palmas)
+tps659038
 
 Required properties:
 - compatible : Should be from the list
@@ -14,6 +15,7 @@ Required properties:
   ti,tps65913
   ti,tps65914
   ti,tps80036
+  ti,tps659038
 and also the generic series names
   ti,palmas
 - interrupt-controller : palmas has its own internal IRQs
-- 
1.7.5.4

