Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaIOGpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 02:45:03 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.109]:17116 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbaIOGpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 02:45:00 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-5.tower-193.messagelabs.com!1410763496!20001853!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 15 Sep 2014 08:44:57 +0200
Date: Mon, 15 Sep 2014 09:36:30 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <linux-kernel@vger.kernel.org>
CC: <andreas.werner@men.de>, <lee.jones@linaro.org>
Subject: [PATCH] MAINTAINERS: Adds Andreas Werner to maintainers list for MEN
 F21BMC
Message-ID: <20140915073625.GA515@awelinux>
References: <cover.1409161615.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1409161615.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added maintainer for the following MEN F21BMC drivers:
	- menf21bmc (MFD)
	- menf21bmc_wdt (Watchdog)
	- menf21bmc_hwmon (HWMON)
	- leds-menf21bmc (LED)

Signed-off-by: Andreas Werner <andreas.werner@men.de>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 65cc66d..c4a188c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5938,6 +5938,15 @@ S:	Supported
 F:	drivers/mcb/
 F:	include/linux/mcb.h
 
+MEN F21BMC (Board Management Controller)
+M:	Andreas Werner <andreas.werner@men.de>
+S:	Supported
+F:	drivers/mfd/menf21bmc.c
+F:	drivers/watchdog/menf21bmc_wdt.c
+F:	drivers/leds/leds-menf21bmc.c
+F:	drivers/hwmon/menf21bmc_hwmon.c
+F:	Documentation/hwmon/menf21bmc
+
 METAG ARCHITECTURE
 M:	James Hogan <james.hogan@imgtec.com>
 L:	linux-metag@vger.kernel.org
-- 
2.0.4

