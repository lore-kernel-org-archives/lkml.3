Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbaLMAi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 19:38:29 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64289 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaLMAi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 19:38:27 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2] MAINTAINERS: Add me as x86 vdso maintainer
Date: Fri, 12 Dec 2014 16:38:23 -0800
Message-Id: <a41f72ad64d5395e81f1de52aa2173029db65f0f.1418431065.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here goes... :)

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Wow, screwing up a MAINTAINERS patch.  I win!

MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e186bf90ed8a..27ab8bcec3a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10476,6 +10476,13 @@ L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	arch/x86/kernel/cpu/mcheck/*
 
+X86 VDSO
+M:	Andy Lutomirski <luto@amacapital.net>
+L:	linux-kernel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/vdso
+S:	Maintained
+F:	arch/x86/vdso/
+
 XC2028/3028 TUNER DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-- 
2.1.0

