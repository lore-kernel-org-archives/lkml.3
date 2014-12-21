Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaLUT5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:57:32 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58154 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaLUTza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:55:30 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] MAINTAINERS: Fix up entry for Dell laptop SMM driver
Date: Sun, 21 Dec 2014 20:54:37 +0100
Message-Id: <1419191683-31435-5-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com>
References: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

Mark driver as maintained.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c444907..2c15f7a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2918,6 +2918,7 @@ F:	drivers/platform/x86/dell-laptop.c
 
 DELL LAPTOP SMM DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
+S:	Maintained
 F:	drivers/char/i8k.c
 F:	include/uapi/linux/i8k.h
 
-- 
1.7.9.5

