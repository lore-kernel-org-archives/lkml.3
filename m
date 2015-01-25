Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbbAYSPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:15:43 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52356 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbbAYSOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:14:21 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] power/reset: st-poweroff: Fix misleading Kconfig description
Date: Sun, 25 Jan 2015 10:13:41 -0800
Message-Id: <1422209622-31994-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
References: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54C5327C.014E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 28
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The st-poweroff driver does not really power off the system
but resets it, so Kconfig should not claim that the driver
would handle power-off.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 720a310..4b4b910 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -111,10 +111,10 @@ config POWER_RESET_RESTART
 	  user presses a key. u-boot then boots into Linux.
 
 config POWER_RESET_ST
-	bool "ST restart power-off driver"
+	bool "ST restart driver"
 	depends on ARCH_STI
 	help
-	  Power off and reset support for STMicroelectronics boards.
+	  Reset support for STMicroelectronics boards.
 
 config POWER_RESET_VERSATILE
 	bool "ARM Versatile family reboot driver"
-- 
2.1.0

