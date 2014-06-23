Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaFWML1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:11:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:35399 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaFWML0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:11:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="551977481"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/3 V2] mei support more devices
Date: Mon, 23 Jun 2014 15:10:34 +0300
Message-Id: <1403525437-4745-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new use case to support secondary head
on mei devices hence we replace misc devices with
char.

V2: use dynamic minor number allocation

Alexander Usyskin (2):
  mei: move from misc to char device
  mei: add WPT second mei interface

Tomas Winkler (1):
  mei: sysfs: add Documentation mei class attributes

 Documentation/ABI/testing/sysfs-class-mei |  16 ++++
 drivers/misc/mei/hw-me-regs.h             |   1 +
 drivers/misc/mei/main.c                   | 148 ++++++++++++++++++++++++------
 drivers/misc/mei/mei_dev.h                |   9 +-
 drivers/misc/mei/pci-me.c                 |   4 +-
 drivers/misc/mei/pci-txe.c                |   2 +-
 6 files changed, 149 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-mei

-- 
1.9.3

