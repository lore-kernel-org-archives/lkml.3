Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3DWN2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:28:44 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36392 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab3DWN2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:28:42 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: generic: Fix typos and clarify comments
Date: Tue, 23 Apr 2013 15:28:38 +0200
Message-Id: <1366723718-5369-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drive strength controls both sink and source currents, clarify the
description accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 include/linux/pinctrl/pinconf-generic.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index 72474e1..1301f15 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -37,17 +37,17 @@
  *	if it is 0, pull-down is disabled.
  * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
  *	low, this is the most typical case and is typically achieved with two
- *	active transistors on the output. Sending this config will enabale
+ *	active transistors on the output. Setting this config will enable
  *	push-pull mode, the argument is ignored.
  * @PIN_CONFIG_DRIVE_OPEN_DRAIN: the pin will be driven with open drain (open
  *	collector) which means it is usually wired with other output ports
- *	which are then pulled up with an external resistor. Sending this
- *	config will enabale open drain mode, the argument is ignored.
+ *	which are then pulled up with an external resistor. Setting this
+ *	config will enable open drain mode, the argument is ignored.
  * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open source
- *	(open emitter). Sending this config will enabale open drain mode, the
+ *	(open emitter). Setting this config will enable open drain mode, the
  *	argument is ignored.
- * @PIN_CONFIG_DRIVE_STRENGTH: the pin will output the current passed as
- * 	argument. The argument is in mA.
+ * @PIN_CONFIG_DRIVE_STRENGTH: the pin will sink or source at most the current
+ *	passed as argument. The argument is in mA.
  * @PIN_CONFIG_INPUT_SCHMITT_ENABLE: control schmitt-trigger mode on the pin.
  *      If the argument != 0, schmitt-trigger mode is enabled. If it's 0,
  *      schmitt-trigger mode is disabled.
-- 
Regards,

Laurent Pinchart

