Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaDAOGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:06:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:48360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaDAOEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,772,1389772800"; 
   d="scan'208";a="504351112"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCHv3 3/5] net: rfkill: gpio: add ACPI ID for GPS module on Lenovo Miix2
Date: Tue,  1 Apr 2014 17:02:54 +0300
Message-Id: <1396360976-28657-4-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Lenovo Miix 2 8", BCM4752 is renamed LNV4752.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 0adda44..fec3dbf 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -173,6 +173,7 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 
 static const struct acpi_device_id rfkill_acpi_match[] = {
 	{ "BCM4752", RFKILL_TYPE_GPS },
+	{ "LNV4752", RFKILL_TYPE_GPS },
 	{ },
 };
 
-- 
1.9.1

