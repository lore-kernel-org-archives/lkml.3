Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaICSCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 14:02:07 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:44304 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaICSCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 14:02:04 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] pinctrl: generic: Fix PIN_CONFIG_DRIVE_OPEN_SOURCE source/drain doc mismatch
Date: Wed,  3 Sep 2014 20:01:55 +0200
Message-Id: <1409767315-8288-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PIN_CONFIG_DRIVE_OPEN_SOURCE enables open source, not open drain.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Yes, we need more open source ;-)

 include/linux/pinctrl/pinconf-generic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index a15f10727eb8..d578a60eff23 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -57,7 +57,7 @@
  *	which are then pulled up with an external resistor. Setting this
  *	config will enable open drain mode, the argument is ignored.
  * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open source
- *	(open emitter). Setting this config will enable open drain mode, the
+ *	(open emitter). Setting this config will enable open source mode, the
  *	argument is ignored.
  * @PIN_CONFIG_DRIVE_STRENGTH: the pin will sink or source at most the current
  *	passed as argument. The argument is in mA.
-- 
1.9.1

