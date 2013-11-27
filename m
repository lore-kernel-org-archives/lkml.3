Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab3K0Qve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:51:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:1377 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757625Ab3K0QvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:51:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,783,1378882800"; 
   d="scan'208";a="443137814"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Siva Krishna Kumar Reddy Yerramreddy 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>
Subject: [PATCH char-misc-linus v3 0/6] misc: mic: Fixes for 3.13-final
Date: Wed, 27 Nov 2013 08:58:37 -0800
Message-Id: <cover.1385527468.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix various issues which were reported or found with the
MIC driver.

Changelog
=========
v2 => v3:
* Reorder patch 5 in v2 to patch 4 in v3.
* Split patch 4 in v2 into patches 5 and 6 in v3.

v1 => v2: @ https://lkml.org/lkml/2013/11/26/376
* Address review comments @ https://lkml.org/lkml/2013/11/26/443
  in patch 5.

v1: Initial post @ https://lkml.org/lkml/2013/11/26/321

Ashutosh Dixit (4):
  misc: mic: Bug fix for sysfs poll usage.
  misc: mic: Fix user space namespace pollution from mic_common.h.
  misc: mic: Fix endianness issues.
  misc: mic: Suppress memory space sparse warnings

Sudeep Dutt (2):
  misc: mic: Change mic_notify(...) to return true.
  misc: mic: Minor bug fix in 'retry' loops.

 Documentation/mic/mpssd/mpssd.c    | 18 +++++++++++------
 drivers/misc/mic/card/mic_virtio.c | 33 +++++++++++++++++--------------
 drivers/misc/mic/card/mic_virtio.h |  7 +++----
 drivers/misc/mic/host/mic_boot.c   |  2 +-
 drivers/misc/mic/host/mic_virtio.c | 30 ++++++++++++++--------------
 drivers/misc/mic/host/mic_x100.c   |  4 ++--
 include/uapi/linux/mic_common.h    | 40 +++++++++++++++-----------------------
 7 files changed, 67 insertions(+), 67 deletions(-)

-- 
1.8.2.3

