Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaGKHzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:55:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33553 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbaGKHzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:55:54 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/2] mtd: nand: add basic SDR NAND timings infrastructure
Date: Fri, 11 Jul 2014 09:49:40 +0200
Message-Id: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These two patches add SDR NAND timings definition and ONFI timing mode to
NAND timings converter.

This infrastructure will be used by NAND controller drivers to configure
their signal timings according to NAND chip capabilities.

Best Regards,

Boris

Boris BREZILLON (2):
  mtd: nand: define struct nand_timings
  mtd: nand: add ONFI timing mode to nand_timings converter

 drivers/mtd/nand/Makefile       |   2 +-
 drivers/mtd/nand/nand_timings.c | 250 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/nand.h        |  52 +++++++++
 3 files changed, 303 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mtd/nand/nand_timings.c

-- 
1.8.3.2

