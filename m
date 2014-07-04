Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbaGDRtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:49:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14618 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759402AbaGDRtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:01 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-27-53b6e908091d
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 04/19] serial: samsung: Remove support for legacy clock code
Date: Fri, 04 Jul 2014 19:48:04 +0200
Message-id: <1404496099-26708-5-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xy7ocL7cFG0xv4bX4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i1a4/jA5cHr9/TWL02Dnr
	LrvHplWdbB6bl9R7XDnRxOrRt2UVo8f2a/OYPT5vkgvgiOKySUnNySxLLdK3S+DKeHd6LXPB
	AvaKWS9msDQwTmHrYuTkkBAwkZjTt5kdwhaTuHBvPVCci0NIYCmjxKN/7ewQTh+TxIc/N8A6
	2ATUJD43PAKzRQRUJT63LQAq4uBgFrjNJNEqDBIWFvCReN16DGwoC1DJ82OHwcp5BZwkbjbu
	ZoJYJifRu+0NM4jNKeAsMXHdBbC4EFDNn//zWSYw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqX
	rpecn7uJERKOX3YwLj5mdYhRgINRiYe3ccWGYCHWxLLiytxDjBIczEoivH9WbQsW4k1JrKxK
	LcqPLyrNSS0+xMjEwSnVwCjxxWPvXXefs4+P8TG2r1yhc+b/I7UdZXNZd0/stp93Jei/tk3/
	jT18wh3J669Gn7HcZ2CzpsGnboX8Cd8jl3Kdg6ZfuFB68U3XdrM56tfVGopuiq9rO2HxOCTU
	rLbF7XLAN0U2o6dyTr6ZppsEPhv+4Obv/fak5U5Me823tYtM1ZjNJZVnbVNiKc5INNRiLipO
	BAD8Or/CJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Samsung platforms are now using the Common Clock Framework and the
legacy clock code is being removed, so remove related dead code from
samsung-serial driver as well.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org> (maintainer:SERIAL DRIVERS)
Cc: Jiri Slaby <jslaby@suse.cz> (supporter:TTY LAYER)
Cc: linux-serial@vger.kernel.org (open list:SERIAL DRIVERS)
---
 drivers/tty/serial/samsung.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 36c7747..cae8ebd 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -47,10 +47,6 @@
 
 #include <asm/irq.h>
 
-#ifdef CONFIG_SAMSUNG_CLOCK
-#include <plat/clock.h>
-#endif
-
 #include "samsung.h"
 
 #if	defined(CONFIG_SERIAL_SAMSUNG_DEBUG) &&	\
-- 
1.9.3

