Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3KKL16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:27:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:12027 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3KKL1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:27:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="406751023"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/3]  mei: driver cleanups 
Date: Mon, 11 Nov 2013 13:26:05 +0200
Message-Id: <1384169168-30281-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** BLURB HERE ***

Alexander Usyskin (1):
  mei: drop redundant list_del_init

Tomas Winkler (2):
  mei: remove flash_work_queue
  mei: cleanup mei_irq_read_handler

 drivers/misc/mei/client.c    |  2 --
 drivers/misc/mei/init.c      | 17 +++++++---
 drivers/misc/mei/interrupt.c | 79 ++++++++++++++++++++++----------------------
 drivers/misc/mei/mei_dev.h   | 13 +++++++-
 drivers/misc/mei/nfc.c       |  6 +++-
 drivers/misc/mei/pci-me.c    |  2 +-
 6 files changed, 70 insertions(+), 49 deletions(-)

-- 
1.8.3.1

