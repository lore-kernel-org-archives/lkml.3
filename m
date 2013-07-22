Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3GVASe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:18:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59801 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755001Ab3GVASd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:18:33 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Kozlov <xeb@mail.ru>, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] MAINTAINERS: Update GRE DEMUX patterns
Date: Sun, 21 Jul 2013 17:15:45 -0700
Message-Id: <23548ed3a55683203fd7432261114a562d16fb7c.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c50cd35788 ("net: gre: move GSO functions to gre_offload")
renamed and separated the file into multiple files.  Update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Dmitry Kozlov <xeb@mail.ru>
cc: Daniel Borkmann <dborkman@redhat.com>
cc: David S. Miller <davem@davemloft.net>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 522ffed..8716e89 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3631,7 +3631,8 @@ GRE DEMULTIPLEXER DRIVER
 M:	Dmitry Kozlov <xeb@mail.ru>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	net/ipv4/gre.c
+F:	net/ipv4/gre_demux.c
+F:	net/ipv4/gre_offload.c
 F:	include/net/gre.h
 
 GRETH 10/100/1G Ethernet MAC device driver
-- 
1.8.1.2.459.gbcd45b4.dirty

