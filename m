Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaEEFZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:25:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:32970 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaEEFZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:25:10 -0400
Subject: [PATCH] powerpc: Fix comment around arch specific definition of
 RECLAIM_DISTANCE
To: linux-kernel@vger.kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Mon, 05 May 2014 10:50:42 +0530
Message-ID: <20140505052041.7795.97381.stgit@preeti>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050505-0928-0000-0000-000001B28D0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 32e45ff43eaf5c17f changed the default value of
RECLAIM_DISTANCE to 30. However the comment around arch
specifc definition of RECLAIM_DISTANCE is not updated to
reflect the same. Correct the value mentioned in the comment.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---

 arch/powerpc/include/asm/topology.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index c920215..356546d 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -12,7 +12,7 @@ struct device_node;
  * Before going off node we want the VM to try and reclaim from the local
  * node. It does this if the remote distance is larger than RECLAIM_DISTANCE.
  * With the default REMOTE_DISTANCE of 20 and the default RECLAIM_DISTANCE of
- * 20, we never reclaim and go off node straight away.
+ * 30, we never reclaim and go off node straight away.
  *
  * To fix this we choose a smaller value of RECLAIM_DISTANCE.
  */

