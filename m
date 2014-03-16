Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaCPMhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 08:37:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:16901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbaCPMhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 08:37:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,664,1389772800"; 
   d="scan'208";a="493061445"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/5] mei: cleanup some checkpatch issues
Date: Sun, 16 Mar 2014 14:35:53 +0200
Message-Id: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Winkler (5):
  mei: fix Unnecessary space after function pointer name
  mei: use cl_dbg where appropriate
  mei: client.h fix checkpetch errors
  mei: amthif: fix checkpatch error
  mei: don't use deprecated DEFINE_PCI_DEVICE_TABLE macro

 drivers/misc/mei/amthif.c  |  3 +--
 drivers/misc/mei/client.h  |  8 ++++----
 drivers/misc/mei/hbm.c     |  3 +--
 drivers/misc/mei/main.c    | 10 ++--------
 drivers/misc/mei/mei_dev.h | 24 ++++++++++++------------
 drivers/misc/mei/pci-me.c  |  2 +-
 drivers/misc/mei/pci-txe.c |  2 +-
 7 files changed, 22 insertions(+), 30 deletions(-)

-- 
1.8.5.3

