Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaCKLGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:06:34 -0400
Received: from mail.zhinst.com ([212.126.164.98]:40362 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaCKLGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:06:33 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Borkmann <dborkman@redhat.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] MAINTAINERS: Add tools/net to NETWORKING [GENERAL]
Date: Tue, 11 Mar 2014 12:06:24 +0100
Message-Id: <1394535984-17924-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure patches for these tools go to the netdev list as well.

References: https://marc.info/?l=linux-kernel&m=139450284501328&w=2
Cc: David S. Miller <davem@davemloft.net>
Cc: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab32ad5..fa7b379 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6042,6 +6042,7 @@ F:	include/linux/netdevice.h
 F:	include/uapi/linux/in.h
 F:	include/uapi/linux/net.h
 F:	include/uapi/linux/netdevice.h
+F:	tools/net/
 
 NETWORKING [IPv4/IPv6]
 M:	"David S. Miller" <davem@davemloft.net>
-- 
1.7.9.5


