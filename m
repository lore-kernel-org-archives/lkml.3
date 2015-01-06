Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbbAFXg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:36:28 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52961 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbAFXg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:36:26 -0500
From: Ani Sinha <ani@arista.com>
To: corbet@lwn.net, davem@davemloft.net, edumazet@google.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ani@arista.com, P@draigbrady.com, netdev@vger.kernel.org,
        fruggeri@arista.com
Subject: [PATCH 1/1] update ip-sysctl.txt documentation
Date: Tue,  6 Jan 2015 15:36:22 -0800
Message-Id: <1420587382-24612-1-git-send-email-ani@arista.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation to reflect the fact that
/proc/sys/net/ipv4/route/max_size is no longer used for ipv4.

Signed-off-by: Ani Sinha <ani@arista.com>
---
 Documentation/networking/ip-sysctl.txt |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 9bffdfc..2a28261 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -64,8 +64,10 @@ fwmark_reflect - BOOLEAN
 	Default: 0
 
 route/max_size - INTEGER
-	Maximum number of routes allowed in the kernel.  Increase
-	this when using large numbers of interfaces and/or routes.
+	Post linux kernel 3.6, this is deprecated for ipv4 as route cache is no
+	longer used. For ipv6, this is used to limit the maximum number of ipv6
+	routes allowed in the kernel.  Increase this when using large numbers of
+	interfaces and/or routes.
 
 neigh/default/gc_thresh1 - INTEGER
 	Minimum number of entries to keep.  Garbage collector will not
-- 
1.7.4.4

