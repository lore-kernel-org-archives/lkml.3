Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3GXPnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:43:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:53657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3GXPna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:43:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="350846024"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/3] mei: export fw status register through sysfs
Date: Wed, 24 Jul 2013 18:41:54 +0300
Message-Id: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Especially comments on the ABI documentation would be appreciated 
I'm not sure I've done that correctly


Tomas Winkler (3):
  mei me: add handler for me_hw_ops fw_status
  mei: adding sysfs fw_status attribute
  mei: update ABI for fw_status register exported through sysfs

 Documentation/ABI/testing/sysfs-devices-mei |  7 ++++
 drivers/misc/mei/hw-me-regs.h               |  9 +++++
 drivers/misc/mei/hw-me.c                    | 30 ++++++++++++++++
 drivers/misc/mei/main.c                     | 54 +++++++++++++++++++++++++++--
 4 files changed, 97 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-mei

-- 
1.8.1.2

