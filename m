Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3EVKUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:20:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:9603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab3EVKUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:20:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="scan'208";a="341306503"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 0/5] gpio-langwell: bugfix and amendments
Date: Wed, 22 May 2013 13:20:09 +0300
Message-Id: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is locking bug fix and few amendments. Each commit message verbose
enoough I think.

Since v2:
 - apply ACKs
 - addressed Mika's comment for patch 3/4
 - append patch 5/5

Since v1:
 - patch 2/4 ("amend error messages") moved to 4/4
 - minor fix in patch 3/4 ("use managed ...")
 - fix patch 4/4 ("amend error messages") to be real amendment

Andy Shevchenko (5):
  gpio-langwell: initialize lock before usage
  gpio-langwell: do not use direct access to iomapped memory
  gpio-langwell: use managed functions pcim_* and devm_*
  gpio-langwell: amend error messages
  gpio-langwell: drop away explicit casting

 drivers/gpio/gpio-langwell.c | 117 ++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 79 deletions(-)

-- 
1.8.2.rc0.22.gb3600c3

