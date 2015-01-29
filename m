Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbbA2MTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:19:53 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:31631 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbbA2MTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:19:51 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH 0/2] dt: dma: Add DMA driver for jz4780
Date: Thu, 29 Jan 2015 12:19:37 +0000
Message-ID: <1422533980-42761-1-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here we have two patches that add a DMA driver for the Ingenic JZ4780 SoC.

JZ4780 support is still in-flight.

See http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/

These are based on 3.19-rc6.

Apart from the channel numbers, jz4740 and jz4780 are quite different.
jz4780 has many more features in hardware.

Hence, we are unable to use the jz4740-dma driver.

ZubairLK

Alex Smith (2):
  dt: dma: Add DT binding document for jz4780-dma
  dma: jz4780: add driver for the Ingenic JZ4780 DMA controller

 .../devicetree/bindings/dma/jz4780-dma.txt         |  59 ++
 drivers/dma/Kconfig                                |  10 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/dma-jz4780.c                           | 856 +++++++++++++++++++++
 include/dt-bindings/dma/jz4780-dma.h               |  49 ++
 5 files changed, 975 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/jz4780-dma.txt
 create mode 100644 drivers/dma/dma-jz4780.c
 create mode 100644 include/dt-bindings/dma/jz4780-dma.h

-- 
1.9.1

