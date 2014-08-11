Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaHKFfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:35:41 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:47990 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaHKFfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:35:38 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>
Date: Mon, 11 Aug 2014 07:35:29 +0200
Subject: RE: [PATCH 17/38] cris: clean-up uapi Kbuild file
Thread-Topic: [PATCH 17/38] cris: clean-up uapi Kbuild file
Thread-Index: Ac+fdZrsmaENGCrESxCq+nvtD8AIBQVsHQFA
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D0589EBFBC0FC@xmail3.se.axis.com>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
 <1405350546-28467-17-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405350546-28467-17-git-send-email-sam@ravnborg.org>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mikael Starvik <mikael.starvik@axis.com>

-----Original Message-----
From: Sam Ravnborg [mailto:sam@ravnborg.org] 
Sent: den 14 juli 2014 17:09
To: Arnd Bergmann
Cc: lkml; linux-arch; Sam Ravnborg; Mikael Starvik; Jesper Nilsson
Subject: [PATCH 17/38] cris: clean-up uapi Kbuild file

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/include/uapi/asm/Kbuild | 31 +------------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

diff --git a/arch/cris/include/uapi/asm/Kbuild b/arch/cris/include/uapi/asm/Kbuild
index 01f66b8..de41e86 100644
--- a/arch/cris/include/uapi/asm/Kbuild
+++ b/arch/cris/include/uapi/asm/Kbuild
@@ -3,37 +3,8 @@ include include/uapi/asm-generic/Kbuild.asm
 
 header-y += ../arch-v10/arch/
 header-y += ../arch-v32/arch/
-header-y += auxvec.h
-header-y += bitsperlong.h
-header-y += byteorder.h
-header-y += errno.h
+
 header-y += ethernet.h
 header-y += etraxgpio.h
-header-y += fcntl.h
-header-y += ioctl.h
-header-y += ioctls.h
-header-y += ipcbuf.h
-header-y += mman.h
-header-y += msgbuf.h
-header-y += param.h
-header-y += poll.h
-header-y += posix_types.h
-header-y += ptrace.h
-header-y += resource.h
 header-y += rs485.h
-header-y += sembuf.h
-header-y += setup.h
-header-y += shmbuf.h
-header-y += sigcontext.h
-header-y += siginfo.h
-header-y += signal.h
-header-y += socket.h
-header-y += sockios.h
-header-y += stat.h
-header-y += statfs.h
-header-y += swab.h
 header-y += sync_serial.h
-header-y += termbits.h
-header-y += termios.h
-header-y += types.h
-header-y += unistd.h
-- 
1.9.3

