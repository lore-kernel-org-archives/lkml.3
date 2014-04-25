Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaDYQWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:22:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:6603 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbaDYQWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:22:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="423954575"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 0/3] Input: gpio-keys - clean up series
Date: Fri, 25 Apr 2014 19:22:14 +0300
Message-Id: <1398442937-15309-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 3rd iteration of the small cleanup against gpio-keys driver.

Changes since v2:
 - append received Acks
 - rebase against recent linux-next
 - test on Intel Medfield based product

Andy Shevchenko (3):
  Input: gpio_keys - use dev instead of pdev in gpio_keys_setup_key()
  Input: gpio_keys - convert to use devm_*
  Input: gpio_keys - convert struct descriptions to kernel-doc

 drivers/input/keyboard/gpio_keys.c | 82 +++++++++++++-------------------------
 include/linux/gpio_keys.h          | 45 +++++++++++++++------
 2 files changed, 61 insertions(+), 66 deletions(-)

-- 
1.9.2

