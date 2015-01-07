Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbbAGXqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:46:05 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:55159 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbbAGXqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:46:00 -0500
From: Ani Sinha <ani@arista.com>
To: corbet@lwn.net, davem@davemloft.net, edumazet@google.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ani@arista.com, P@draigbrady.com, netdev@vger.kernel.org,
        fruggeri@arista.com
Subject: [PATCH 1/1] update ip-sysctl.txt documentation (v2)
Date: Wed,  7 Jan 2015 15:45:56 -0800
Message-Id: <1420674356-32210-1-git-send-email-ani@arista.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation to reflect the fact that
/proc/sys/net/ipv4/route/max_size is no longer used for ipv4.

Signed-off-by: Ani Sinha <ani@arista.com>
---
 Documentation/networking/ip-sysctl.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 9bffdfc..85b0221 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -66,6 +66,8 @@ fwmark_reflect - BOOLEAN
 route/max_size - INTEGER
 	Maximum number of routes allowed in the kernel.  Increase
 	this when using large numbers of interfaces and/or routes.
+	From linux kernel 3.6 onwards, this is deprecated for ipv4
+	as route cache is no longer used.
 
 neigh/default/gc_thresh1 - INTEGER
 	Minimum number of entries to keep.  Garbage collector will not
-- 
1.7.4.4

