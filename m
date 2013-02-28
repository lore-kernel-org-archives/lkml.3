Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3B1A6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:58:23 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:55247 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3B1A6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:58:22 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/2] of: dma: make #dma-cells optional
Date: Wed, 27 Feb 2013 18:57:57 -0600
Message-Id: <1362013078-2213-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

For controllers with no requests/clients (memory to memory only), the

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 Documentation/devicetree/bindings/dma/dma.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/dma.txt b/Documentation/devicetree/bindings/dma/dma.txt
index 8f504e6..d388f06 100644
--- a/Documentation/devicetree/bindings/dma/dma.txt
+++ b/Documentation/devicetree/bindings/dma/dma.txt
@@ -8,9 +8,10 @@ controller.
 * DMA controller
 
 Required property:
-- #dma-cells: 		Must be at least 1. Used to provide DMA controller
-			specific information. See DMA client binding below for
-			more details.
+- #dma-cells: 		Required for controllers with requests. Optional for
+			memory to memory only DMA controllers. Must be at least
+			1. Used to provide DMA controller specific information. 
+			See DMA client binding below for more details.
 
 Optional properties:
 - dma-channels: 	Number of DMA channels supported by the controller.
-- 
1.7.10.4

