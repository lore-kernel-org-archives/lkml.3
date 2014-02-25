Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaBYMWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:22:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:35456 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaBYMWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:22:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="481424939"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCHv2 1/5] ARM: tegra: remove obsolete gpio entries
Date: Tue, 25 Feb 2014 14:22:26 +0200
Message-Id: <1393330950-7283-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After moving to description based gpio interface in
rfkill-gpio, the gpio numbers are not used any more.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 arch/arm/mach-tegra/board-paz00.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index e4dec9f..9c6029b 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -23,9 +23,7 @@
 #include "board.h"
 
 static struct rfkill_gpio_platform_data wifi_rfkill_platform_data = {
-	.name		= "wifi_rfkill",
-	.reset_gpio	= 25, /* PD1 */
-	.shutdown_gpio	= 85, /* PK5 */
+	.name	= "wifi_rfkill",
 	.type	= RFKILL_TYPE_WLAN,
 };
 
-- 
1.9.0.rc3

