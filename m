Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab3GCIpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:45:11 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:52304 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3GCIow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:44:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,987,1363132800"; 
   d="scan'208";a="6325033"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: am33xx dt binding: correct include path
Date: Wed, 3 Jul 2013 09:44:50 +0100
Message-ID: <1372841090-14750-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using #include <include/...> is a bit odd. It happens to work because the DTC
flags include -Iarch/FOO/boot/dts as well as arch/FOO/boot/dts/include and
arch/FOO/boot/dts/include/dt-bindings is a symlink to include/dt-bindings.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
---
 include/dt-bindings/pinctrl/am33xx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/dt-bindings/pinctrl/am33xx.h b/include/dt-bindings/pinctrl/am33xx.h
index 469e032..2fbc804 100644
--- a/include/dt-bindings/pinctrl/am33xx.h
+++ b/include/dt-bindings/pinctrl/am33xx.h
@@ -5,7 +5,7 @@
 #ifndef _DT_BINDINGS_PINCTRL_AM33XX_H
 #define _DT_BINDINGS_PINCTRL_AM33XX_H
 
-#include <include/dt-bindings/pinctrl/omap.h>
+#include <dt-bindings/pinctrl/omap.h>
 
 /* am33xx specific mux bit defines */
 #undef PULL_ENA
-- 
1.7.10.4

