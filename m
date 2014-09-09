Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaIIFVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:21:06 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:36081 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaIIFVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:21:03 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Zankel <chris@zankel.net>,
        "Max Filippov linux-xtensa @ linux-xtensa . org" <jcmvbkbc@gmail.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/2] xtensa/uapi: Add definition of TIOC[SG]RS485
Date: Tue,  9 Sep 2014 07:20:56 +0200
Message-Id: <1410240056-22786-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 [3/21] serial/8250: Add
support for RS485 IOCTLs, adds support for RS485 ioctls for 825_core on
all the archs. Unfortunaltely the definition of TIOCSRS485 and
TIOCGRS485 was missing on the ioctls.h file

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 arch/xtensa/include/uapi/asm/ioctls.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/xtensa/include/uapi/asm/ioctls.h b/arch/xtensa/include/uapi/asm/ioctls.h
index a47909f..accda82 100644
--- a/arch/xtensa/include/uapi/asm/ioctls.h
+++ b/arch/xtensa/include/uapi/asm/ioctls.h
@@ -95,6 +95,8 @@
 #define TCSETS2		_IOW('T', 43, struct termios2)
 #define TCSETSW2	_IOW('T', 44, struct termios2)
 #define TCSETSF2	_IOW('T', 45, struct termios2)
+#define TIOCGRS485	0x542E
+#define TIOCSRS485	0x542F
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
-- 
2.1.0

