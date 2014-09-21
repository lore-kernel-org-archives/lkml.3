Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaIUIBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 04:01:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:53795 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaIUIBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 04:01:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,564,1406617200"; 
   d="scan'208";a="478959586"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/4] mei: docmentation cleanup
Date: Sun, 21 Sep 2014 11:00:12 +0300
Message-Id: <1411286416-15339-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overall documentation formating fix and other collateral 
fixes.


Alexander Usyskin (4):
  mei: trivial: fix errors in prints in comments
  mei: drop me_client_presentation_num
  mei: fix KDoc documentation formatting
  mei: fix kernel-doc warnings

 drivers/misc/mei/amthif.c    |  35 +++----
 drivers/misc/mei/client.c    |  78 +++++++++------
 drivers/misc/mei/debugfs.c   |  11 +-
 drivers/misc/mei/hbm.c       |  47 +++++----
 drivers/misc/mei/hw-me.c     |  89 +++++++++++------
 drivers/misc/mei/hw-me.h     |   6 ++
 drivers/misc/mei/hw-txe.c    | 116 ++++++++++++++--------
 drivers/misc/mei/hw-txe.h    |   1 +
 drivers/misc/mei/hw.h        |  48 ++++-----
 drivers/misc/mei/init.c      |  12 +--
 drivers/misc/mei/interrupt.c |  28 +++---
 drivers/misc/mei/main.c      |  21 ++--
 drivers/misc/mei/mei_dev.h   | 232 +++++++++++++++++++++++++++++--------------
 drivers/misc/mei/nfc.c       |   8 +-
 drivers/misc/mei/pci-me.c    |  10 +-
 drivers/misc/mei/pci-txe.c   |   2 +-
 drivers/misc/mei/wd.c        |  15 ++-
 17 files changed, 469 insertions(+), 290 deletions(-)

-- 
1.9.3

