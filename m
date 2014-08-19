Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaHSHfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:35:03 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:42712 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbaHSHfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:35:00 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] kbuild: remove redundant clean-files from scripts/kconfig/Makefile
Date: Tue, 19 Aug 2014 16:34:23 +0900
Message-Id: <1408433663-17435-5-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408433663-17435-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1408433663-17435-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now mconf, qconf, gconf, nconf are always added to hostprogs-y.
Files added to hostprogs-y are removed by "make clean".

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 scripts/kconfig/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 76f6171..e7bf38e 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -161,7 +161,6 @@ hostprogs-y := conf nconf mconf kxgettext qconf gconf
 
 clean-files	:= qconf.moc .tmp_qtcheck .tmp_gtkcheck
 clean-files	+= zconf.tab.c zconf.lex.c zconf.hash.c gconf.glade.h
-clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot
 
 # Check that we have the required ncurses stuff installed for lxdialog (menuconfig)
-- 
1.9.1

