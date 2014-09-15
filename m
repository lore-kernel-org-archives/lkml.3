Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaIOUYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:24:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41257 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753921AbaIOUYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:24:08 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/2] mtd: nand: gpmi: add proper raw access support
Date: Mon, 15 Sep 2014 22:24:01 +0200
Message-Id: <1410812643-14041-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Huang, Brian,

This is just a new proposal to support raw accesses in a more standard way
in the GPMI driver.
This series was not tested (just compile tested), and I won't be able to
test it until next week. Thus I don't expect to get it accepted, but
rather to serve as a starting point for our future discussions.

Any suggestions are welcome.

Best Regards,

Boris

Boris BREZILLON (2):
  mtd: nand: gpmi: add gpmi_move_bits function
  mtd: nand: gpmi: add proper raw access support

 drivers/mtd/nand/gpmi-nand/gpmi-lib.c  |  86 ++++++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 118 ++++++++++++++++++++++++++++++++-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   4 ++
 3 files changed, 207 insertions(+), 1 deletion(-)

-- 
1.9.1

