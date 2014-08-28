Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936357AbaH1IfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:35:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:14162 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998AbaH1IfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:35:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,416,1406617200"; 
   d="scan'208";a="582782637"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org
Cc: srinivas.pandruvada@linux.intel.com, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, laurentiu.palcu@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] iio: accel: BMC150: add support for more Bosch chips
Date: Thu, 28 Aug 2014 11:35:03 +0300
Message-Id: <1409214906-27038-1-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patchset fixes a couple of minor issues with the BMC150
accelerometer driver and, also, adds support for more Bosch accelerometer chips
that are basically identical to BMC150 or have only the resolution different.
So, it makes sense to reuse this existing driver.

All the accelerometer chips were tested using the eval boards provided by
Bosch.

laurentiu

Laurentiu Palcu (3):
  iio: accel: BMC150: fix scale value for 16G
  iio: accel: BMC150: fix issues when CONFIG_PM_RUNTIME is not set
  iio: accel: BMC150: add support for other Bosch chips

 drivers/iio/accel/bmc150-accel.c | 238 ++++++++++++++++++++++++++++++---------
 1 file changed, 184 insertions(+), 54 deletions(-)

-- 
1.9.1

