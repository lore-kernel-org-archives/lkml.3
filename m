Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbaCSWQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:16:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44256 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbaCSWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:16:34 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH 0/2] Disable subpage write for k2hk-evm
Date: Thu, 20 Mar 2014 00:15:43 +0200
Message-ID: <1395267345-27795-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches disable subpage write for k2hk-evm.

Based on linux-next
tag: next-20140319

Ivan Khoronzhuk (2):
  mtd: davinci-nand: add dts property for NAND_NO_SUBPAGE_WRITE option
  ARM: dts: keystone: disable subpage write for davinci nand device

 Documentation/devicetree/bindings/mtd/davinci-nand.txt | 2 ++
 arch/arm/boot/dts/k2hk-evm.dts                         | 1 +
 drivers/mtd/nand/davinci_nand.c                        | 3 +++
 3 files changed, 6 insertions(+)

-- 
1.8.3.2

