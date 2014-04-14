Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbaDNWHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:07:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:3329 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbaDNWHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:07:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,859,1389772800"; 
   d="scan'208";a="520716153"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [Patch v5 0/6] Quaternion support
Date: Mon, 14 Apr 2014 15:11:01 -0700
Message-Id: <1397513467-21397-1-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v5:
Only change is for aligning function paramaters as suggested by Joe Perches


Srinivas Pandruvada (6):
  devres: introduce API "devm_kmemdup
  IIO: core: Introduce read_raw_multi
  IIO: core: Modify scan element type
  IIO: core: Add quaternion modifier
  iio: hid-sensors: Added device rotation support
  iio: Added ABI description for quaternion

 Documentation/ABI/testing/sysfs-bus-iio       |  12 +
 Documentation/driver-model/devres.txt         |   1 +
 drivers/base/devres.c                         |  21 ++
 drivers/iio/iio_core.h                        |   2 +-
 drivers/iio/industrialio-buffer.c             |  41 ++-
 drivers/iio/industrialio-core.c               |  66 +++--
 drivers/iio/industrialio-event.c              |   6 +-
 drivers/iio/inkern.c                          |  16 +-
 drivers/iio/orientation/Kconfig               |  12 +
 drivers/iio/orientation/Makefile              |   1 +
 drivers/iio/orientation/hid-sensor-rotation.c | 348 ++++++++++++++++++++++++++
 include/linux/device.h                        |   2 +
 include/linux/hid-sensor-ids.h                |   1 +
 include/linux/iio/iio.h                       |  26 ++
 include/linux/iio/types.h                     |   2 +
 15 files changed, 524 insertions(+), 33 deletions(-)
 create mode 100644 drivers/iio/orientation/hid-sensor-rotation.c

-- 
1.7.11.7

