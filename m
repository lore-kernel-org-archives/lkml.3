Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab3KZR4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:56:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:22849 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3KZR4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:56:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,776,1378882800"; 
   d="scan'208";a="442464423"
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
Subject: [PATCH char-misc-linus 0/5] misc: mic: Fixes for 3.13-rc2
Date: Tue, 26 Nov 2013 10:04:38 -0800
Message-Id: <cover.1385487752.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix various issues which were reported or found with the
MIC driver.

Ashutosh Dixit (3):
  misc: mic: Bug fix for sysfs poll usage.
  misc: mic: Fix sparse warnings and other endianness issues.
  misc: mic: Fix user space namespace pollution from mic_common.h.

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

