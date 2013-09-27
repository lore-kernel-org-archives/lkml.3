Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3I0BKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:10:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:6858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3I0BKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,989,1371106800"; 
   d="scan'208";a="384180278"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH CHAR-MISC-NEXT 0/4] Intel MIC Driver Cleanups.
Date: Thu, 26 Sep 2013 18:09:41 -0700
Message-Id: <cover.1380241770.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches address code review feedback received on the patch
series @ https://lkml.org/lkml/2013/9/5/561 ,from:
a) Greg Kroah-Hartman on sysfs and header file cleanups.
b) Joe Perches on issues found by "--strict" checkpatch.

Ashutosh Dixit (1):
  Intel MIC Driver Cleanups for "--strict" checkpatch.

Sudeep Dutt (3):
  Intel MIC Host Driver Sysfs Cleanups.
  Intel MIC Driver Header File Cleanups.
  Intel MIC Header File warning fix.

 Documentation/mic/mpssd/mpssd.c      | 65 +++++++++++++------------
 Documentation/mic/mpssd/sysfs.c      |  4 +-
 drivers/misc/mic/card/mic_debugfs.c  |  2 +-
 drivers/misc/mic/card/mic_device.c   |  3 +-
 drivers/misc/mic/card/mic_virtio.c   | 19 ++++----
 drivers/misc/mic/card/mic_x100.c     |  6 +--
 drivers/misc/mic/common/mic_dev.h    | 51 +++++++++++++++++++
 drivers/misc/mic/common/mic_device.h | 51 -------------------
 drivers/misc/mic/host/mic_boot.c     |  2 +-
 drivers/misc/mic/host/mic_debugfs.c  | 92 +++++++++++++++++------------------
 drivers/misc/mic/host/mic_fops.c     |  8 +--
 drivers/misc/mic/host/mic_intr.c     | 36 +++++++-------
 drivers/misc/mic/host/mic_main.c     |  2 +-
 drivers/misc/mic/host/mic_smpt.c     | 16 +++---
 drivers/misc/mic/host/mic_sysfs.c    | 94 +++++++++++++++---------------------
 drivers/misc/mic/host/mic_virtio.c   | 39 +++++++--------
 drivers/misc/mic/host/mic_x100.c     | 35 ++++++--------
 include/uapi/linux/mic_ioctl.h       |  2 +
 18 files changed, 253 insertions(+), 274 deletions(-)
 create mode 100644 drivers/misc/mic/common/mic_dev.h
 delete mode 100644 drivers/misc/mic/common/mic_device.h

-- 
1.8.2.1

