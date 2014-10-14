Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbaJNOtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:49:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:9508 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaJNOtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:49:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,717,1406617200"; 
   d="scan'208";a="614288451"
From: Octavian Purdila <octavian.purdila@intel.com>
To: wsa@the-dreams.de
Cc: linux@roeck-us.net, johan@kernel.org, linux-i2c@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH v2 0/3] i2c: show and change bus frequency via sysfs
Date: Tue, 14 Oct 2014 17:48:11 +0300
Message-Id: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This second version gets rid of the frequency table and introduces a
min and max range. It also changes the ABI to allow the driver to
round the given frequency to one that is supported, since many drivers
seems to work this way (i2c-stu300, i2c-s3c2410, i2c-kempld).

Octavian Purdila (3):
  i2c: document the existing i2c sysfs ABI
  i2c: document struct i2c_adapter
  i2c: show and change bus frequency via sysfs

 Documentation/ABI/testing/sysfs-bus-i2c | 75 ++++++++++++++++++++++++++
 drivers/i2c/i2c-core.c                  | 94 +++++++++++++++++++++++++++++++++
 include/linux/i2c.h                     | 32 +++++++++--
 3 files changed, 198 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c

-- 
1.9.1

