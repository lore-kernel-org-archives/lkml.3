Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab3IPUqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:46:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:18077 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3IPUqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:46:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,918,1371106800"; 
   d="scan'208";a="295571739"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/7] mei minor fixes and cleanups
Date: Mon, 16 Sep 2013 23:44:41 +0300
Message-Id: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexander Usyskin (1):
  mei: fix function names in debug prints

Tomas Winkler (6):
  mei: propagate error from write routines instead of ENODEV
  mei: push credentials inside the irq write handler
  mei: mei_cl_unlink: no need to loop over dev list
  mei: simplify mei_open error handling
  mei: revamp open handler counts
  mei: amthif: mei_amthif_host_init: propagate errors from called
    functions

 drivers/misc/mei/amthif.c    | 49 +++++++++++++++++----------
 drivers/misc/mei/client.c    | 81 +++++++++++++++++++++++++++++++-------------
 drivers/misc/mei/hbm.c       |  2 +-
 drivers/misc/mei/init.c      |  5 ---
 drivers/misc/mei/interrupt.c | 31 +++++++++--------
 drivers/misc/mei/main.c      | 37 ++++++++------------
 drivers/misc/mei/mei_dev.h   |  1 +
 7 files changed, 122 insertions(+), 84 deletions(-)

-- 
1.8.3.1

