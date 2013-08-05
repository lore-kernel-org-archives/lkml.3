Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3HEIrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:47:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:47774 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab3HEIq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:46:58 -0400
X-IronPort-AV: E=Sophos;i="4.89,817,1367942400"; 
   d="scan'208";a="8120907"
From: Hu Tao <hutao@cn.fujitsu.com>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: [PATCH] doc: fix a typo about irq affinity
Date: Mon, 5 Aug 2013 16:45:40 +0800
Message-Id: <1375692340-21590-1-git-send-email-hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/05 16:45:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/05 16:45:37,
	Serialize complete at 2013/08/05 16:45:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_affinity holds bitmask and smp_affinity_list holds list. So we
should write a list to smp_affinity_list, instead of smp_affinity.

Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 Documentation/IRQ-affinity.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/IRQ-affinity.txt b/Documentation/IRQ-affinity.txt
index 7890fae..01a6751 100644
--- a/Documentation/IRQ-affinity.txt
+++ b/Documentation/IRQ-affinity.txt
@@ -57,8 +57,8 @@ i.e counters for the CPU0-3 did not change.
 
 Here is an example of limiting that same irq (44) to cpus 1024 to 1031:
 
-[root@moon 44]# echo 1024-1031 > smp_affinity
-[root@moon 44]# cat smp_affinity
+[root@moon 44]# echo 1024-1031 > smp_affinity_list
+[root@moon 44]# cat smp_affinity_list
 1024-1031
 
 Note that to do this with a bitmask would require 32 bitmasks of zero
-- 
1.8.1.4

