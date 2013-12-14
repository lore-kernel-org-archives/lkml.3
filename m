Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3LNRb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:27 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34301 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab3LNRar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:47 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 09/14] i8k: Add copyright
Date: Sat, 14 Dec 2013 09:30:16 -0800
Message-Id: <1387042221-3671-10-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made enough changes to the driver to warrant adding a copyright notice.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 264be2b..6aed11f 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -5,6 +5,7 @@
  *
  * Hwmon integration:
  * Copyright (C) 2011  Jean Delvare <khali@linux-fr.org>
+ * Copyright (C) 2013  Guenter Roeck <linux@roeck-us.net>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
-- 
1.7.9.7

