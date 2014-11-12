Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaKLNva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:51:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaKLNv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:51:28 -0500
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RESEND] Documentation: devicetree: Fix Xilinx VDMA specification
Date: Wed, 12 Nov 2014 14:51:16 +0100
Message-Id: <1415800277-6817-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The specification requires xlnx,data-width, but example and driver use
xlnx,datawidth. Change the specification to match the implementation.

Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Fixes: eebeac03db93 ("dma: Add Xilinx Video DMA DT Binding Documentation")
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 This appears to have fallen through the cracks... resending to dmaengine.

 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
index 1405ed071bb4..e4c4d47f8137 100644
--- a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
+++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
@@ -25,7 +25,7 @@ Required child node properties:
 - compatible: It should be either "xlnx,axi-vdma-mm2s-channel" or
 	"xlnx,axi-vdma-s2mm-channel".
 - interrupts: Should contain per channel VDMA interrupts.
-- xlnx,data-width: Should contain the stream data width, take values
+- xlnx,datawidth: Should contain the stream data width, take values
 	{32,64...1024}.
 
 Optional child node properties:
-- 
2.1.2

