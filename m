Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaFYDaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 23:30:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20536 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752423AbaFYDaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 23:30:13 -0400
X-IronPort-AV: E=Sophos;i="5.00,773,1396972800"; 
   d="scan'208";a="32392783"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] cgroup: fix a typo in Documentation/cgroups/cgroups.txt
Date: Wed, 25 Jun 2014 11:30:25 +0800
Message-ID: <1403667025-13422-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/iff/if

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 821de56..b614f42 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -562,7 +562,7 @@ cgroup_for_each_descendant_pre() for details.
 void css_offline(struct cgroup *cgrp);
 (cgroup_mutex held by caller)
 
-This is the counterpart of css_online() and called iff css_online()
+This is the counterpart of css_online() and called if css_online()
 has succeeded on @cgrp. This signifies the beginning of the end of
 @cgrp. @cgrp is being removed and the subsystem should start dropping
 all references it's holding on @cgrp. When all references are dropped,
-- 
1.9.0

