Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3AXICF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:02:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39591 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab3AXICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:02:03 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>,
        <zonque@gmail.com>, <jacmet@sunsite.dk>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH v2 0/3] Add device tree support for NAND flash in am335x-evm
Date: Thu, 24 Jan 2013 13:32:26 +0530
Message-ID: <cover.1359007746.git.avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds device tree support for NAND flash in am335x-evm.
Also ELM node is populated in device tree and been used for BCH error
correction in NAND flash part. Also this patch series ensures RBL ecc
layout maintained in Linux kernel with BCH8 ecc scheme.

This patch series based on [1] and depends on [2].

1. http://git.kernel.org/?p=linux/kernel/git/bcousson/linux-omap-dt.git;a=tree;h=refs/heads/for_3.9/dts;hb=refs/heads/for_3.9/dts

2.mtd: devices: elm: Removes <xx> literals in elm DT node
  https://lkml.org/lkml/2013/1/24/30

Philip Avinash (1):
  ARM: dts: AM33XX: Add NAND flash device tree data to am335x-evm

Philip, Avinash (2):
  ARM: dts: AM33XX: Add ELM node
  ARM: dts: AM33XX: Add GPMC node

 arch/arm/boot/dts/am335x-evm.dts |   98 +++++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/am33xx.dtsi    |   20 ++++++++
 2 files changed, 117 insertions(+), 1 deletion(-)

-- 
1.7.9.5

