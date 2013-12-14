Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3LNRbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:18 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38686 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3LNRal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:41 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 05/14] MAINTAINERS: Add myself as i8k maintainer
Date: Sat, 14 Dec 2013 09:30:12 -0800
Message-Id: <1387042221-3671-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a couple of Dell laptops running Linux, so I have a vested
interest to keep this driver supported.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 13c15c8..7bc4772 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2618,7 +2618,7 @@ S:	Maintained
 F:	drivers/platform/x86/dell-laptop.c
 
 DELL LAPTOP SMM DRIVER
-S:	Orphan
+M:	Guenter Roeck <linux@roeck-us.net>
 F:	drivers/char/i8k.c
 F:	include/uapi/linux/i8k.h
 
-- 
1.7.9.7

