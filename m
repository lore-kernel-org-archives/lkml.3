Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3CCByQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:54:16 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:48587 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3CCByP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:15 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH 04/14] MAINTAINERS: fix drivers/media/i2c/cx2341x.c
Date: Sat,  2 Mar 2013 22:53:42 -0300
Message-Id: <1362275632-20242-5-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file was moved to drivers/media/common/ by commit 6259582 ([media]
cx2341x: move from media/i2c to media/common).

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5af82f9..261b245 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2286,7 +2286,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Maintained
-F:	drivers/media/i2c/cx2341x*
+F:	drivers/media/common/cx2341x*
 F:	include/media/cx2341x*
 
 CX88 VIDEO4LINUX DRIVER
-- 
1.7.11.7

