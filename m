Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3CCByT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:54:19 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:56414 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3CCByP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:15 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Alessandro Rubini <rubini@unipv.it>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/14] MAINTAINERS: remove arch/arm/plat-nomadik/
Date: Sat,  2 Mar 2013 22:53:40 -0300
Message-Id: <1362275632-20242-3-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The files within that directory were moved to other places over the
course of several commits. I only added the ones moved in the patch
series which finally removed the directory; untangling the rest will
take more work, since some seem to be shared with ux500.

In fact, the ARM/Ux500 ARM ARCHITECTURE block has patterns for files
named "nomadik" too. The patterns in this pair of MAINTAINER blocks
really need a review from the respective maintainters.

Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b64aa5..3c074d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1009,8 +1009,11 @@ M:	STEricsson <STEricsson_nomadik_linux@list.st.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-nomadik/
-F:	arch/arm/plat-nomadik/
+F:	drivers/clocksource/nomadik-mtu.c
 F:	drivers/i2c/busses/i2c-nomadik.c
+F:	include/linux/platform_data/clocksource-nomadik-mtu.h
+F:	include/linux/platform_data/dma-ste-dma40.h
+F:	include/linux/platform_data/pinctrl-nomadik.h
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-nomadik.git
 
 ARM/OPENMOKO NEO FREERUNNER (GTA02) MACHINE SUPPORT
-- 
1.7.11.7

