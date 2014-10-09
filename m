Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaJIUHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:07:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:50899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbaJIUHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,687,1406617200"; 
   d="scan'208";a="586274738"
From: Octavian Purdila <octavian.purdila@intel.com>
To: wsa@the-dreams.de
Cc: johan@kernel.org, linux-i2c@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 0/3] i2c: show and change bus frequency via sysfs
Date: Thu,  9 Oct 2014 23:07:12 +0300
Message-Id: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two patches are just general cleanup the actual
implementation is in patch 3. If the general direction looks
acceptable, I will send a follow-up series that adds sysfs bus
frequency support to the existing drivers.

Octavian Purdila (3):
  i2c: document the existing i2c sysfs ABI
  i2c: document struct i2c_adapter
  i2c: show and change bus frequency via sysfs

 Documentation/ABI/testing/sysfs-bus-i2c | 69 +++++++++++++++++++++++++++++
 drivers/i2c/i2c-core.c                  | 77 +++++++++++++++++++++++++++++++++
 include/linux/i2c.h                     | 26 +++++++++--
 3 files changed, 169 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c

-- 
1.9.1

