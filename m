Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3HRUdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:33:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab3HRUdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-cris-kernel@axis.com
Subject: [ 10/34] cris: posix_types.h, include asm-generic/posix_types.h
Date: Sun, 18 Aug 2013 13:34:23 -0700
Message-Id: <20130818203300.393648477@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 74f077d2a7651409c44bb323471f219a4b0d2aab upstream.

Without that I cannot build anything:
In file included from include/linux/page-flags.h:8:0,
                 from kernel/bounds.c:9:
include/linux/types.h:25:1: error: unknown type name '__kernel_ino_t'
include/linux/types.h:29:1: error: unknown type name '__kernel_off_t'
...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/cris/include/asm/posix_types.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/cris/include/asm/posix_types.h
+++ b/arch/cris/include/asm/posix_types.h
@@ -33,4 +33,6 @@ typedef int		__kernel_ptrdiff_t;
 typedef unsigned short	__kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
+#include <asm-generic/posix_types.h>
+
 #endif /* __ARCH_CRIS_POSIX_TYPES_H */


