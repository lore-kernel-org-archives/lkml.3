Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3LNRbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:19 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39598 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab3LNRam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:42 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 06/14] i8k: Remove obsolete link to out-of-tree driver
Date: Sat, 14 Dec 2013 09:30:13 -0800
Message-Id: <1387042221-3671-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing the link returns a page not found error.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index ef56bb0..5b3682c 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -1,7 +1,5 @@
 /*
  * i8k.c -- Linux driver for accessing the SMM BIOS on Dell laptops.
- *	    See http://www.debian.org/~dz/i8k/ for more information
- *	    and for latest version of this driver.
  *
  * Copyright (C) 2001  Massimo Dal Zotto <dz@debian.org>
  *
-- 
1.7.9.7

