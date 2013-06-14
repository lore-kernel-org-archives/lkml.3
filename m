Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab3FNCmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:42:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33993 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932452Ab3FNCmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:42:33 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 29/33] ndisc: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:54 -0700
Message-Id: <9c7afffd58958d72a5f99c2e7f298b9824716f02.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/ndisc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 745bf74..949d775 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -230,7 +230,7 @@ extern int 			ndisc_ifinfo_sysctl_change(struct ctl_table *ctl,
 							   void __user *buffer,
 							   size_t *lenp,
 							   loff_t *ppos);
-int ndisc_ifinfo_sysctl_strategy(ctl_table *ctl,
+int ndisc_ifinfo_sysctl_strategy(struct ctl_table *ctl,
 				 void __user *oldval, size_t __user *oldlenp,
 				 void __user *newval, size_t newlen);
 #endif
-- 
1.8.1.2.459.gbcd45b4.dirty

