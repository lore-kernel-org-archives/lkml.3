Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbaEMIXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:23:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:52024 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaEMIW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:22:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1042,1389772800"; 
   d="scan'208";a="510767465"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/3] mei support more devices
Date: Tue, 13 May 2014 11:21:58 +0300
Message-Id: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new use case to support secondary head
on mei devices hence we replace misc devices with 
char.

Alexander Usyskin (2):
  mei: move from misc to char device
  mei: add WPT second mei interface

Tomas Winkler (1):
  mei: sysfs: add Documentation mei class attributes

 Documentation/ABI/testing/sysfs-class-mei | 23 ++++++++
 drivers/misc/mei/hw-me-regs.h             |  1 +
 drivers/misc/mei/hw-me.c                  |  5 ++
 drivers/misc/mei/hw-me.h                  |  1 +
 drivers/misc/mei/main.c                   | 98 ++++++++++++++++++++++---------
 drivers/misc/mei/mei_dev.h                |  9 +++
 drivers/misc/mei/pci-me.c                 |  2 +-
 7 files changed, 111 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-mei

-- 
1.9.0

