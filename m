Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaE0BaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:30:19 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:54144 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaE0BaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:30:15 -0400
X-Greylist: delayed 2837 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2014 21:30:15 EDT
From: gxt@mprc.pku.edu.cn
To: linux-kernel@vger.kernel.org
Cc: gang.chen.5i5j@gmail.com, sunzc522@gmail.com,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH] UniCore32: Change git tree location information in MAINTAINERS
Date: Tue, 27 May 2014 08:04:51 +0800
Message-Id: <1401149091-20380-1-git-send-email-gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

UniCore32 git repo has moved to github.
Branch 'unicore32' is used for prepared patches, and automatically merged to linux-next.
Branch 'unicore32-working' is used for development.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 764075d..6d59899 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6885,7 +6885,7 @@ PKUNITY SOC DRIVERS
 M:	Guan Xuetao <gxt@mprc.pku.edu.cn>
 W:	http://mprc.pku.edu.cn/~guanxuetao/linux
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
+T:	git git://github.com/gxt/linux.git
 F:	drivers/input/serio/i8042-unicore32io.h
 F:	drivers/i2c/busses/i2c-puv3.c
 F:	drivers/video/fb-puv3.c
@@ -9165,7 +9165,7 @@ UNICORE32 ARCHITECTURE:
 M:	Guan Xuetao <gxt@mprc.pku.edu.cn>
 W:	http://mprc.pku.edu.cn/~guanxuetao/linux
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
+T:	git git://github.com/gxt/linux.git
 F:	arch/unicore32/
 
 UNIFDEF
-- 
1.7.0.4

