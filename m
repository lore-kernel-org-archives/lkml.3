Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaBINfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:35:14 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:50044 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbaBINfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:35:13 -0500
Message-ID: <1391952911.25424.7.camel@x220>
Subject: [PATCH] rcu: disambiguate CONFIG_RCU_NOCB_CPUs
From: Paul Bolle <pebolle@tiscali.nl>
To: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 14:35:11 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 13:35:12.0044 (UTC) FILETIME=[C1E89EC0:01CF259B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6e2ef4b..366e21e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2893,7 +2893,7 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
  * CPU unless the grace period has extended for too long.
  *
  * This code relies on the fact that all NO_HZ_FULL CPUs are also
- * CONFIG_RCU_NOCB_CPUs.
+ * CONFIG_RCU_NOCB_CPU CPUs.
  */
 static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
 {
-- 
1.8.5.3

