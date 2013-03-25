Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3CYW7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:59:19 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:61397 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702Ab3CYW7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:59:18 -0400
Message-ID: <1364252356.1390.303.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix typo "CONFIG_CGROUP_CGROUP_MEMCG_SWAP"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 23:59:16 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 22:59:17.0172 (UTC) FILETIME=[60938F40:01CE29AC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/cgroups/memory.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 8b8c28b..17b91e0 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -194,7 +194,7 @@ the cgroup that brought it in -- this will happen on memory pressure).
 But see section 8.2: when moving a task to another cgroup, its pages may
 be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
 
-Exception: If CONFIG_CGROUP_CGROUP_MEMCG_SWAP is not used.
+Exception: If CONFIG_MEMCG_SWAP is not used.
 When you do swapoff and make swapped-out pages of shmem(tmpfs) to
 be backed into memory in force, charges for pages are accounted against the
 caller of swapoff rather than the users of shmem.
-- 
1.7.11.7

