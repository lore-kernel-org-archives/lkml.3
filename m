Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3CCB5O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:57:14 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:35084 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3CCByP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:15 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH 05/14] MAINTAINERS: remove drivers/net/wan/cycx*
Date: Sat,  2 Mar 2013 22:53:43 -0300
Message-Id: <1362275632-20242-6-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was removed by commit 6fcdf4f (wanrouter: delete now
orphaned header content, files/drivers).

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 261b245..e909cd3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2357,12 +2357,6 @@ W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	drivers/video/cyber2000fb.*
 
-CYCLADES 2X SYNC CARD DRIVER
-M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
-W:	http://oops.ghostprotocols.net:81/blog
-S:	Maintained
-F:	drivers/net/wan/cycx*
-
 CYCLADES ASYNC MUX DRIVER
 W:	http://www.cyclades.com/
 S:	Orphan
-- 
1.7.11.7

