Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3CCB4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:56:33 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:40463 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3CCByR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:17 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 09/14] MAINTAINERS: fix Documentation/video4linux/saa7134/
Date: Sat,  2 Mar 2013 22:53:47 -0300
Message-Id: <1362275632-20242-10-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That directory never existed. The intention was probably to match
CARDLIST.saa7134 and README.saa7134.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 46c1288..44b9f69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6741,7 +6741,7 @@ L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
-F:	Documentation/video4linux/saa7134/
+F:	Documentation/video4linux/*.saa7134
 F:	drivers/media/pci/saa7134/
 
 SAA7146 VIDEO4LINUX-2 DRIVER
-- 
1.7.11.7

