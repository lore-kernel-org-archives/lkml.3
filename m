Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaG1JQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:16:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37553 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751759AbaG1JQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:16:56 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/2] mtd: nand: support ONFI timings mode retrieval for non-ONFI NANDs
Date: Mon, 28 Jul 2014 11:16:50 +0200
Message-Id: <1406539012-16320-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following the series adding ONFI timings mode support, here is a series
adding support for timings mode retrieval on non-ONFI NANDs.

It just adds a new field to the nand_chip and nand_flash_dev struct so
that anyone can define its chip requirements in the nand_ids table.

The 2nd patch serves as an example and adds an entry for the Hynix
H27UCG8T2ATR-BC NAND chip used on the Cubietruck board.

Best Regards,

Boris

Boris BREZILLON (2):
  mtd: nand: support ONFI timing mode retrieval for non-ONFI NANDs
  mtd: nand: add Hynix's H27UCG8T2ATR-BC to nand_ids table

 drivers/mtd/nand/nand_base.c | 1 +
 drivers/mtd/nand/nand_ids.c  | 4 ++++
 include/linux/mtd/nand.h     | 7 +++++++
 3 files changed, 12 insertions(+)

-- 
1.8.3.2

