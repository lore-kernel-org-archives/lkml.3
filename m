Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3CCB5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:57:13 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:57791 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3CCByP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:15 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-edac@vger.kernel.org
Subject: [PATCH 06/14] MAINTAINERS: fix drivers/edac/ghes-edac.c
Date: Sat,  2 Mar 2013 22:53:44 -0300
Message-Id: <1362275632-20242-7-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e909cd3..2e1443c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2899,7 +2899,7 @@ M:	Mauro Carvalho Chehab <mchehab@redhat.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
-F:	drivers/edac/ghes-edac.c
+F:	drivers/edac/ghes_edac.c
 
 EDAC-I82443BXGX
 M:	Tim Small <tim@buttersideup.com>
-- 
1.7.11.7

