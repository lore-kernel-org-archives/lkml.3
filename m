Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3GJLzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:55:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:64337 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3GJLzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1035,1363158000"; 
   d="scan'208";a="266364923"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/5] pinctrl-baytrail: miscellaneous minor fixes
Date: Wed, 10 Jul 2013 14:55:35 +0300
Message-Id: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of small minor fixes against pinctrl-baytrail driver.

Andy Shevchenko (5):
  pinctrl-baytrail: fix indentations
  pinctrl-baytrail: change lvl to level
  pinctrl-baytrail: remove redundant ptr variable
  pinctrl-baytrail: introduce to_byt_gpio() macro
  pinctrl-baytrail: fix to avoid sparse warnings

 drivers/pinctrl/Kconfig            |  2 +-
 drivers/pinctrl/pinctrl-baytrail.c | 37 +++++++++++++++++++++----------------
 2 files changed, 22 insertions(+), 17 deletions(-)

-- 
1.8.3.2

