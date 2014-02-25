Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaBYWSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:18:35 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20550 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaBYWSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:18:33 -0500
X-IronPort-AV: E=Sophos;i="4.97,542,1389772800"; 
   d="scan'208";a="16790686"
From: Markus Mayer <markus.mayer@linaro.org>
To: Matt Porter <matt.porter@linaro.org>, Christian Daudt <bcm@fixthebug.org>
CC: ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] ARM: bcm281xx: Re-order hearder files
Date: Tue, 25 Feb 2014 14:17:45 -0800
Message-ID: <1393366666-28625-4-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
References: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-order header files alphabetically.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/mach-bcm/board_bcm281xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-bcm/board_bcm281xx.c b/arch/arm/mach-bcm/board_bcm281xx.c
index e0d0bc5e..fe00ff3 100644
--- a/arch/arm/mach-bcm/board_bcm281xx.c
+++ b/arch/arm/mach-bcm/board_bcm281xx.c
@@ -11,9 +11,9 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/of_platform.h>
-#include <linux/of_address.h>
 #include <linux/clocksource.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
 
 #include <asm/mach/arch.h>
 
-- 
1.7.9.5

