Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3CJL4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:56:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:8940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab3CJL4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:56:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,817,1355126400"; 
   d="scan'208";a="299148001"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 0/2][3.9] Lynx Point LP Bug Fixes for 3.9
Date: Sun, 10 Mar 2013 13:56:06 +0200
Message-Id: <1362916568-9650-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg
Please, if possible schedule these patches for 3.9 update.
The patches fix the reset/initialization for Lynx Point LP (dev_id: 0x9C3A)
devices to be found in the Haswell systems.

This not a regression per se but it's a fix for a new device.

Tomas Winkler (2):
  mei: ME hw reset need to be synchoronous
  mei: add mei_stop function to stop mei device

 drivers/misc/mei/hw-me.c   | 35 +++++++++++++++++-------------
 drivers/misc/mei/init.c    | 16 ++++++++++++++
 drivers/misc/mei/mei_dev.h |  1 +
 drivers/misc/mei/pci-me.c  | 53 +++++-----------------------------------------
 4 files changed, 42 insertions(+), 63 deletions(-)

-- 
1.8.1.3

