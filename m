Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3C0O7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:59:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:29553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab3C0O7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:59:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,919,1355126400"; 
   d="scan'208";a="276679415"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/5] MEI: move mei-me to separate module
Date: Wed, 27 Mar 2013 16:58:25 +0200
Message-Id: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This completes the separation of the me hardware form mei
layer to give space for adding another underlying hardware

ME hardware is now encapsulated into mei-me module.



Tomas Winkler (5):
  mei: unregister watchdog from mei_stop function
  mei: ME structures should be initialized in mei_device_init
  mei: rename function mei_hw_init to mei_start
  mei: prefix me hardware specific functions with mei_me_
  mei: move mei-me to separate module

 drivers/misc/mei/Kconfig     |  5 ++---
 drivers/misc/mei/Makefile    |  6 ++++--
 drivers/misc/mei/hw-me.c     | 44 ++++++++++++++++++--------------------------
 drivers/misc/mei/init.c      | 21 ++++++++++++++++++---
 drivers/misc/mei/interrupt.c |  4 ++++
 drivers/misc/mei/main.c      |  4 ++++
 drivers/misc/mei/mei_dev.h   |  2 +-
 drivers/misc/mei/pci-me.c    | 40 +++++++++++++++++++---------------------
 8 files changed, 70 insertions(+), 56 deletions(-)

-- 
1.7.11.7

