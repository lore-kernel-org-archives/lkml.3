Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaHAGO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 02:14:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49558 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaHAGOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 02:14:11 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <robh+dt@kernel.org>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/6] ARM: DT/davinci: Audio for da850-evm in DT boot
Date: Fri, 1 Aug 2014 09:13:24 +0300
Message-ID: <1406873610-5037-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v1:
- fixed the address missmatch for tlv320aic3106 codec (@1b -> 18)
- The edma patches has been taken by Vinod, they should be in linux-next soon.

The following series will enable audio via simple card on the board when booted
with DT.

For edma one patch is needed to have working dma:
http://marc.info/?l=linux-omap&m=140680159327749&w=2

Regards,
Peter
---
Peter Ujfalusi (6):
  ARM: davinci: da8xx-dt: add OF_DEV_AUXDATA entry for mcasp0
  ARM: DTS: da850: Add node for edma0
  ARM: DTS: da850: Add node for McASP
  ARM: DTS: da850-evm: Enable McASP via DT boot
  ARM: DTS: da850-evm: Add node for tlv320aic3106 codec
  ARM: DTS: da850-evm: Enable audio via simple-card

 arch/arm/boot/dts/da850-evm.dts  | 72 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/da850.dtsi     | 19 +++++++++++
 arch/arm/mach-davinci/da8xx-dt.c |  1 +
 3 files changed, 92 insertions(+)

-- 
2.0.2

