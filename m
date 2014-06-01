Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaFAJdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 05:33:23 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:57249 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaFAJdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 05:33:21 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] MAINTAINERS: drop two usb-serial subdriver entries
Date: Sun,  1 Jun 2014 11:32:17 +0200
Message-Id: <1401615137-11862-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the remaining two obsolete usb-serial subdriver entries from
MAINTAINERS, which were missed in the recent purge by commit
f896b7968b62 ("USB: Maintainers change for usb serial drivers").

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 MAINTAINERS | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51ebb779c5f3..68599b26f514 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9298,12 +9298,6 @@ S:	Maintained
 F:	drivers/usb/host/isp116x*
 F:	include/linux/usb/isp116x.h
 
-USB KAWASAKI LSI DRIVER
-M:	Oliver Neukum <oliver@neukum.org>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-F:	drivers/usb/serial/kl5kusb105.*
-
 USB MASS STORAGE DRIVER
 M:	Matthew Dharm <mdharm-usb@one-eyed-alien.net>
 L:	linux-usb@vger.kernel.org
@@ -9331,12 +9325,6 @@ S:	Maintained
 F:	Documentation/usb/ohci.txt
 F:	drivers/usb/host/ohci*
 
-USB OPTION-CARD DRIVER
-M:	Matthias Urlichs <smurf@smurf.noris.de>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-F:	drivers/usb/serial/option.c
-
 USB PEGASUS DRIVER
 M:	Petko Manolov <petkan@nucleusys.com>
 L:	linux-usb@vger.kernel.org
-- 
1.8.5.5

