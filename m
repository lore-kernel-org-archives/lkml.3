Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbaCTRHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:07:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44840 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaCTRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:07:45 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <galak@codeaurora.org>, <santosh.shilimkar@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <grygorii.strashko@ti.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH 0/3] Fix NAND propeties for k2hk-evm
Date: Thu, 20 Mar 2014 19:06:21 +0200
Message-ID: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is intedent to fix problems founded when checked NAND flash
for k2hk-emv board rev2.0. Whithout this series we cannot use ubifs and
whole volume of present NAND memory.

Based on linux-next tag: next-20140320

Murali Karicheri (3):
  ARM: dts: k2hk-evm: set ubifs partition size for 512M NAND
  mtd: davinci-nand: add dts property for NAND_NO_SUBPAGE_WRITE option
  ARM: dts: k2hk-evm: disable subpage write for davinci nand device

 Documentation/devicetree/bindings/mtd/davinci-nand.txt | 2 ++
 arch/arm/boot/dts/k2hk-evm.dts                         | 3 ++-
 drivers/mtd/nand/davinci_nand.c                        | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

-- 
1.8.3.2

