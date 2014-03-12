Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaCLOCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:02:16 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:47102 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaCLOB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:01:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] serial: max310x: Add missing #include <linux/uaccess.h>
Date: Wed, 12 Mar 2014 15:01:54 +0100
Message-Id: <1394632915-20585-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cris allmodconfig:

drivers/tty/serial/max310x.c: In function 'max310x_ioctl':
drivers/tty/serial/max310x.c:885:3: error: implicit declaration of function 'copy_from_user' [-Werror=implicit-function-declaration]
drivers/tty/serial/max310x.c:916:3: error: implicit declaration of function 'copy_to_user' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/10701747/
---
 drivers/tty/serial/max310x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 471dbc1e2b58..2a99d0c61b9e 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -27,6 +27,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/spi/spi.h>
+#include <linux/uaccess.h>
 
 #define MAX310X_NAME			"max310x"
 #define MAX310X_MAJOR			204
-- 
1.7.9.5

