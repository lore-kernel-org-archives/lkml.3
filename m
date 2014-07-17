Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbaGQHzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:55:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:22293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaGQHy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:54:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,676,1400050800"; 
   d="scan'208";a="574532083"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/5] mei: corner cases bug fixes
Date: Thu, 17 Jul 2014 10:53:33 +0300
Message-Id: <1405583618-8229-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set of fixes that covers few corner cases

Alexander Usyskin (5):
  mei: reset client connection state on timeout
  mei: start disconnect request timer consistently
  mei: don't schedule suspend in pm idle
  mei: nfc: clean nfc internal struct on host exit
  mei: fix return value on disconnect timeout

 drivers/misc/mei/client.c  | 17 +++++++----------
 drivers/misc/mei/nfc.c     |  1 +
 drivers/misc/mei/pci-me.c  |  2 +-
 drivers/misc/mei/pci-txe.c |  2 +-
 4 files changed, 10 insertions(+), 12 deletions(-)

-- 
1.9.3

