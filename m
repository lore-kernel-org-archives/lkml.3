Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaLaMQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:16:04 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:34962 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073AbaLaMQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:16:02 -0500
X-Greylist: delayed 2143 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2014 07:16:01 EST
From: Rameshwar Prasad Sahu <rsahu@apm.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ddutile@redhat.com, jcm@redhat.com, patches@apm.com,
        Rameshwar Prasad Sahu <rsahu@apm.com>, Loc Ho <lho@apm.com>
Subject: [PATCH v1 0/3] dmaengine: APM X-Gene SoC DMA driver support
Date: Wed, 31 Dec 2014 17:08:30 +0530
Message-Id: <1420025913-17597-1-git-send-email-rsahu@apm.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set implements the APM X-Gene SoC DMA driver
support to offload the DMA operations such as memory copy(memcpy),
scatter gathering.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
Signed-off-by: Loc Ho <lho@apm.com>
---

Rameshwar Prasad Sahu (3):
  dmaengine: Add support for APM X-Gene SoC DMA driver
  arm64: dts: Add APM X-Gene DMA device and DMA clock DTS node
  Documentation: dma: Add APM X-Gene SoC DMA driver documentation

 .../devicetree/bindings/dma/apm-xgene-dma.txt      |   49 +
 arch/arm64/boot/dts/apm/apm-storm.dtsi             |   25 +
 drivers/dma/Kconfig                                |    8 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/xgene-dma.c                            | 1506 ++++++++++++++++++++
 5 files changed, 1589 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/apm-xgene-dma.txt
 create mode 100644 drivers/dma/xgene-dma.c

--
1.8.2.1

