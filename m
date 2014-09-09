Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaIISGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:06:39 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:33068 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaIISGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:06:36 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: "James E . J . Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/3] parisc/uapi: Add definition of TIOC[SG]RS485
Date: Tue,  9 Sep 2014 20:06:31 +0200
Message-Id: <1410285991-24833-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 (serial/8250: Add
support for RS485 IOCTLs), adds support for RS485 ioctls for 825_core on
all the archs. Unfortunaltely the definition of TIOCSRS485 and
TIOCGRS485 was missing on the ioctls.h file

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 arch/parisc/include/uapi/asm/ioctls.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/parisc/include/uapi/asm/ioctls.h b/arch/parisc/include/uapi/asm/ioctls.h
index 66719c3..3af2d02 100644
--- a/arch/parisc/include/uapi/asm/ioctls.h
+++ b/arch/parisc/include/uapi/asm/ioctls.h
@@ -50,6 +50,8 @@
 #define TCSETS2		_IOW('T',0x2B, struct termios2)
 #define TCSETSW2	_IOW('T',0x2C, struct termios2)
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
+#define TIOCGRS485	0x542E
+#define TIOCSRS485	0x542F
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 #define TIOCGDEV	_IOR('T',0x32, int)  /* Get primary device node of /dev/console */
-- 
2.1.0

