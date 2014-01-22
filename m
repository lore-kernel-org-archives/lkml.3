Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaAVQ5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:57:50 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:44591 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaAVQ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:57:44 -0500
From: Srikanth Thokala <sthokal@xilinx.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH v2] Add Xilinx AXI Video DMA Engine driver
Date: Wed, 22 Jan 2014 22:22:44 +0530
Message-Id: <1390409565-4200-1-git-send-email-sthokal@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the driver for Xilinx AXI Video Direct Memory Access Engine.
It is a soft IP core, which provides high-bandwidth direct memory
access between memory and AXI4-Stream video type target peripherals
including peripherals which support AXI4-Stream Video Protocol. The
core provides efficient two dimensional DMA operations with independent
asynchronous read and write channel operation.

For more information on the IP, please refer to
http://www.xilinx.com/support/documentation/ip_documentation/axi_vdma/v6_1/pg020_axi_vdma.pdf

Use cases:
++++++++++
1. Xilinx Video Targeted Reference design
   http://www.wiki.xilinx.com/Zynq+Base+TRD+14.5
2. Common Display Framework
   http://events.linuxfoundation.org/sites/events/files/slides/20131024-elce.pdf

Regards,
Srikanth 

Srikanth Thokala (1):
  dma: Add Xilinx AXI Video Direct Memory Access Engine driver support

 .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   75 +
 drivers/dma/Kconfig                                |   14 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/xilinx/Makefile                        |    1 +
 drivers/dma/xilinx/xilinx_vdma.c                   | 1486 ++++++++++++++++++++
 include/linux/amba/xilinx_dma.h                    |   50 +
 6 files changed, 1627 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
 create mode 100644 drivers/dma/xilinx/Makefile
 create mode 100644 drivers/dma/xilinx/xilinx_vdma.c
 create mode 100644 include/linux/amba/xilinx_dma.h

-- 
1.7.9.5

