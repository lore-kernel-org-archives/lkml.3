Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3LQN54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:57:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:37779 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3LQN5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:57:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,501,1384329600"; 
   d="scan'208";a="453616818"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/2] mei: support DMA transactions
Date: Tue, 17 Dec 2013 15:56:55 +0200
Message-Id: <1387288617-18043-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prerequisites to support DMA transactions.

Tomas Winkler (2):
  mei: enable marking internal commands
  mei: me: set dma mask using DMA mapping API

 drivers/misc/mei/amthif.c  |  2 ++
 drivers/misc/mei/client.c  |  2 ++
 drivers/misc/mei/hw.h      |  3 ++-
 drivers/misc/mei/mei_dev.h |  5 +++--
 drivers/misc/mei/pci-me.c  | 15 +++++++++++++++
 drivers/misc/mei/wd.c      |  1 +
 6 files changed, 25 insertions(+), 3 deletions(-)

-- 
1.8.3.1

