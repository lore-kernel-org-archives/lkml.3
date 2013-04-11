Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936571Ab3DKBDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:03:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:58976 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935511Ab3DKBDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:03:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,451,1363158000"; 
   d="scan'208";a="320606668"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 0/3 v7] Support NFC device on MEI CL bus 
Date: Thu, 11 Apr 2013 03:03:28 +0200
Message-Id: <1365642211-21421-1-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v6 -> v7:
   * Removed include/uapi/linux/mei/nfc.h.
     All MEI NFC definitions are now folded into drivers/misc/mei/nfc.c

Samuel Ortiz (3):
  mei: nfc: Initial nfc implementation
  mei: nfc: Add NFC device to the MEI bus
  mei: nfc: Implement MEI bus ops

 drivers/misc/mei/Makefile  |    1 +
 drivers/misc/mei/client.c  |    3 +
 drivers/misc/mei/init.c    |    2 +
 drivers/misc/mei/mei_dev.h |   10 +
 drivers/misc/mei/nfc.c     |  554 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 570 insertions(+)
 create mode 100644 drivers/misc/mei/nfc.c

-- 
1.7.10.4

