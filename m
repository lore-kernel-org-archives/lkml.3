Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaIWOHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:07:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58022 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755344AbaIWOHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:07:42 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 0/3] mtd: nand: gpmi: add proper raw access support
Date: Tue, 23 Sep 2014 16:07:33 +0200
Message-Id: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Huang, Brian,

This is just a new proposal to support raw accesses in a more standard way
in the GPMI driver.
This series has been tested on an imx28 board.

Any suggestions are welcome.

Best Regards,

Boris

Changes since v2:
 - fixed a bug in gpmi_move_bits
 - add a raw_buffer field to be used when using raw access methods
   (experienced memory corruptions when directly using page_buffer_virt
   buffer)
 - add raw OOB access functions

Boris BREZILLON (3):
  mtd: nand: gpmi: add gpmi_move_bits function
  mtd: nand: gpmi: add proper raw access support
  mtd: nand: gpmi: add raw oob access functions

 drivers/mtd/nand/gpmi-nand/gpmi-lib.c  |  88 ++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 144 +++++++++++++++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   6 ++
 3 files changed, 238 insertions(+)

-- 
1.9.1

