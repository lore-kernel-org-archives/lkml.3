Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaI2Ncp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:32:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:2354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaI2Nco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:32:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393029904"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 00/18] mei: resend of rebased patches
Date: Mon, 29 Sep 2014 16:31:32 +0300
Message-Id: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend of two series that haven't applied 
1. Remove pci dependencies from mei module to support testing hw module 
2. Overall documentation formating fix and other collateral fixes.

Added two more cleanups:
mei: drop me_client_presentation_num
mei: trivial: fix errors in prints in comments
 

Alexander Usyskin (6):
  mei: add hbm and pg state in devstate debugfs print
  mei: debugfs: adjust print buffer
  mei: trivial: fix errors in prints in comments
  mei: drop me_client_presentation_num
  mei: fix KDoc documentation formatting
  mei: fix kernel-doc warnings

Tomas Winkler (12):
  mei: debugfs: add single buffer indicator
  mei: pg: fix cat and paste error in comments
  mei: fix style warning: Missing a blank line after declarations
  mei: nfc: fix style warning
  mei: kill error message for allocation failure
  mei: move mei_hbm_hdr function from hbm.h the hbm.c
  mei: push all standard settings into mei_device_init
  mei: get rid of most of the pci dependencies in mei
  mei: move fw_status back to hw ops handlers
  mei: remove the reference to pdev from mei_device
  mei: push pci cfg structure me hw
  mei: remove include to pci header from mei module files

 drivers/misc/mei/amthif.c    | 110 +++++++++---------
 drivers/misc/mei/bus.c       |  11 +-
 drivers/misc/mei/client.c    | 127 ++++++++++++---------
 drivers/misc/mei/client.h    |   4 +-
 drivers/misc/mei/debugfs.c   |  53 ++++++---
 drivers/misc/mei/hbm.c       | 155 +++++++++++++++----------
 drivers/misc/mei/hbm.h       |  11 +-
 drivers/misc/mei/hw-me.c     | 175 +++++++++++++++++++---------
 drivers/misc/mei/hw-me.h     |  32 +++++-
 drivers/misc/mei/hw-txe.c    | 252 +++++++++++++++++++++++++---------------
 drivers/misc/mei/hw-txe.h    |   6 +-
 drivers/misc/mei/hw.h        |  48 ++++----
 drivers/misc/mei/init.c      | 104 ++++++++---------
 drivers/misc/mei/interrupt.c |  75 ++++++------
 drivers/misc/mei/main.c      |  64 +++++------
 drivers/misc/mei/mei_dev.h   | 265 ++++++++++++++++++++++++++++---------------
 drivers/misc/mei/nfc.c       |  56 ++++-----
 drivers/misc/mei/pci-me.c    |  14 +--
 drivers/misc/mei/pci-txe.c   |  13 ++-
 drivers/misc/mei/wd.c        |  50 ++++----
 include/linux/mei_cl_bus.h   |   1 +
 21 files changed, 966 insertions(+), 660 deletions(-)

-- 
1.9.3

