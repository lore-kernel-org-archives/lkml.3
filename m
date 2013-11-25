Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3KYOpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:45:15 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58452 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3KYOpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:45:13 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] pinctrl: provide documentation pointer
Date: Mon, 25 Nov 2013 15:45:06 +0100
Message-Id: <1385390706-28722-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PIN_CONFIG_OUTPUT parameter is really tricky to understand
and needs an explicit pointer to the documentation.

Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/pinctrl/pinconf-generic.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index fb90ef5eb038..4b1432548e9e 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -83,7 +83,9 @@
  *	passed in the argument on a custom form, else just use argument 1
  *	to indicate low power mode, argument 0 turns low power mode off.
  * @PIN_CONFIG_OUTPUT: this will configure the pin in output, use argument
- *	1 to indicate high level, argument 0 to indicate low level.
+ *	1 to indicate high level, argument 0 to indicate low level. (Please
+ *	Documentation/pinctrl.txt, section "GPIO mode pitfalls" for a
+ *	discussion around this parameter.)
  * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
  *	you need to pass in custom configurations to the pin controller, use
  *	PIN_CONFIG_END+1 as the base offset.
-- 
1.8.3.1

