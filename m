Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaIIGiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:38:25 -0400
Received: from leviathan.tchmachines.com ([208.76.85.180]:58246 "EHLO
	leviathan.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbaIIGiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:38:24 -0400
From: Eli Billauer <eli.billauer@gmail.com>
To: gregkh@linuxfoundation.org, arnd@arndb.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH] MAINTAINERS: Move Xillybus out of staging
Date: Tue,  9 Sep 2014 09:38:01 +0300
Message-Id: <1410244681-25756-1-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - leviathan.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - billauer.co.il
X-Get-Message-Sender-Via: leviathan.tchmachines.com: authenticated_id: billaue/sender_address_domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 MAINTAINERS |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f040e7f..95bcdee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8789,12 +8789,6 @@ M:	Arnaud Patard <arnaud.patard@rtp-net.org>
 S:	Odd Fixes
 F:	drivers/staging/xgifb/
 
-STAGING - XILLYBUS DRIVER
-M:	Eli Billauer <eli.billauer@gmail.com>
-L:	devel@driverdev.osuosl.org
-S:	Supported
-F:	drivers/staging/xillybus/
-
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
@@ -10203,6 +10197,12 @@ L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/tty/serial/uartlite.c
 
+XILLYBUS DRIVER
+M:	Eli Billauer <eli.billauer@gmail.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	drivers/char/xillybus/
+
 XTENSA XTFPGA PLATFORM SUPPORT
 M:	Max Filippov <jcmvbkbc@gmail.com>
 L:	linux-xtensa@linux-xtensa.org
-- 
1.7.2.3

