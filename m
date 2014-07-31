Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbaGaKTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:19:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55940 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbaGaKTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:19:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <robh+dt@kernel.org>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] ARM: DT/davinci: Audio for da850-evm in DT boot
Date: Thu, 31 Jul 2014 13:18:48 +0300
Message-ID: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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

