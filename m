Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaIISIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:08:39 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40987 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaIISIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:08:35 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 3/3] sparc/uapi: Add definition of TIOC[SG]RS485
Date: Tue,  9 Sep 2014 20:08:30 +0200
Message-Id: <1410286110-24956-1-git-send-email-ricardo.ribalda@gmail.com>
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
 arch/sparc/include/uapi/asm/ioctls.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/include/uapi/asm/ioctls.h b/arch/sparc/include/uapi/asm/ioctls.h
index 897d172..4e1c5da 100644
--- a/arch/sparc/include/uapi/asm/ioctls.h
+++ b/arch/sparc/include/uapi/asm/ioctls.h
@@ -24,6 +24,8 @@
 #define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
 #define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
 #define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
+#define TIOCGRS485	0x542E
+#define TIOCSRS485	0x542F
 
 /* Note that all the ioctls that are not available in Linux have a 
  * double underscore on the front to: a) avoid some programs to
-- 
2.1.0

