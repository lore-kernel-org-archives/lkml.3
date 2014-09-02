Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaIBLvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:51:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:30414 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbaIBLvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="585035590"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/6] mei: remove pci dependency from mei module
Date: Tue,  2 Sep 2014 14:49:58 +0300
Message-Id: <1409658604-31615-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support testing hw module we remove dependency on
pci from mei module

Tomas Winkler (6):
  mei: push all standard settings into mei_device_init
  mei: get rid of most of the pci dependencies in mei
  mei: move fw_status back to hw ops handlers
  mei: remove the reference to pdev from mei_deivce
  mei: push pci cfg structure me hw
  mei: remove include to pci header from mei module files

 drivers/misc/mei/amthif.c    |  70 +++++++++++++--------------
 drivers/misc/mei/bus.c       |  11 ++---
 drivers/misc/mei/client.c    |  48 +++++++++----------
 drivers/misc/mei/client.h    |   4 +-
 drivers/misc/mei/debugfs.c   |   7 ++-
 drivers/misc/mei/hbm.c       |  71 ++++++++++++++--------------
 drivers/misc/mei/hw-me.c     |  70 ++++++++++++++++++---------
 drivers/misc/mei/hw-me.h     |  26 ++++++++++-
 drivers/misc/mei/hw-txe.c    | 109 +++++++++++++++++++++++++------------------
 drivers/misc/mei/hw-txe.h    |   5 +-
 drivers/misc/mei/init.c      |  78 +++++++++++++------------------
 drivers/misc/mei/interrupt.c |  46 +++++++++---------
 drivers/misc/mei/main.c      |  42 ++++++++---------
 drivers/misc/mei/mei_dev.h   |  37 ++++++---------
 drivers/misc/mei/nfc.c       |  46 +++++++++---------
 drivers/misc/mei/pci-me.c    |   4 +-
 drivers/misc/mei/pci-txe.c   |  10 ++--
 drivers/misc/mei/wd.c        |  35 ++++++--------
 include/linux/mei_cl_bus.h   |   1 +
 19 files changed, 377 insertions(+), 343 deletions(-)

-- 
1.9.3

