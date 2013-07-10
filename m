Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3GJL4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:56:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:27191 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab3GJL4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1035,1363158000"; 
   d="scan'208";a="329265522"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/5] pinctrl-baytrail: change lvl to level
Date: Wed, 10 Jul 2013 14:55:37 +0300
Message-Id: <1373457340-16666-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additionally remove trailing whitespace when print triggering type.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index fccf72e..06ffeee 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -296,7 +296,7 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			   conf0 & 0x7,
 			   conf0 & BYT_TRIG_NEG ? "fall " : "",
 			   conf0 & BYT_TRIG_POS ? "rise " : "",
-			   conf0 & BYT_TRIG_LVL ? "lvl " : "");
+			   conf0 & BYT_TRIG_LVL ? "level" : "");
 	}
 	spin_unlock_irqrestore(&vg->lock, flags);
 }
-- 
1.8.3.2

