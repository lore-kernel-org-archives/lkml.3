Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab3ARGk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:40:56 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41429 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3ARGkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:40:55 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <zonque@gmail.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 0/3] Add device tree support for NAND flash in am335x-evm
Date: Fri, 18 Jan 2013 12:11:32 +0530
Message-ID: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
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

This patch series based on [1] and depends on [2] & [3].

1. http://git.kernel.org/?p=linux/kernel/git/bcousson/linux-omap-dt.git;a=tree;h=refs/heads/for_3.9/dts;hb=refs/heads/for_3.9/dts
2. OMAP GPMC DT bindings
   http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;a=shortlog;h=refs/heads/omap-for-v3.9/gpmc
3. mtd: nand: OMAP: ELM error correction support for BCH ecc
   http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/shortlog/refs/heads/master


Philip Avinash (1):
  ARM: dts: AM33XX: Add NAND flash device tree data to am335x-evm

Philip, Avinash (2):
  ARM: dts: AM33XX: Add ELM node
  ARM: dts: AM33XX: Add GPMC node

 arch/arm/boot/dts/am335x-evm.dts |   93 +++++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/am33xx.dtsi    |   18 ++++++++
 2 files changed, 110 insertions(+), 1 deletion(-)

-- 
1.7.9.5

