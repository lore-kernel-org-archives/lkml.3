Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3EUKdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:33:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:50133 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3EUKdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="244554735"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/4] gpio-langwell: bugfix and amendments
Date: Tue, 21 May 2013 13:33:02 +0300
Message-Id: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is locking bug fix and few amendments. Each commit message verbose
enoough I think.

Andy Shevchenko (4):
  gpio-langwell: initialize lock before usage
  gpio-langwell: amend error messages
  gpio-langwell: do not use direct access to iomapped memory
  gpio-langwell: use managed functions pcim_* and devm_*

 drivers/gpio/gpio-langwell.c | 93 +++++++++++++-------------------------------
 1 file changed, 28 insertions(+), 65 deletions(-)

-- 
1.8.2.rc0.22.gb3600c3

