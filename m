Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaIVSL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:11:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50849 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754553AbaIVSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:11:56 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Yassin Jaffer <yassinjaffer@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 0/2] mtd: nand: support ONFI timings mode retrieval for non-ONFI NANDs
Date: Mon, 22 Sep 2014 20:11:49 +0200
Message-Id: <1411409511-4381-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following the series adding ONFI timing mode support, here is a series
adding support for timing mode retrieval on non-ONFI NANDs.

It just adds a new field to the nand_chip and nand_flash_dev struct so
that anyone can define its chip requirements in the nand_ids table.

The 2nd patch serves as an example and adds an entry for the Hynix
H27UCG8T2ATR-BC NAND chip used on the Cubietruck board.

Best Regards,

Boris

Changes since v2:
- fix checkpatch warnings

Changes since v1:
- fix H27UCG8T2ATR-BC definition
- rename onfi_timing_mode_ds field into onfi_timing_mode_default

Boris BREZILLON (2):
  mtd: nand: support ONFI timing mode retrieval for non-ONFI NANDs
  mtd: nand: add Hynix's H27UCG8T2ATR-BC to nand_ids table

 drivers/mtd/nand/nand_base.c |  2 ++
 drivers/mtd/nand/nand_ids.c  |  4 ++++
 include/linux/mtd/nand.h     | 11 +++++++++++
 3 files changed, 17 insertions(+)

-- 
1.9.1

