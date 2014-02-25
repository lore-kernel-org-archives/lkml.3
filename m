Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaBYHmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:42:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60041 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaBYHmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:42:10 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <530C48F8.3000707@jp.fujitsu.com>
Date: Tue, 25 Feb 2014 16:40:40 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] rcu: Copyright string update
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix corporate name for copyright.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 include/linux/srcu.h |    2 +-
 kernel/rcu/srcu.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 9b058ee..04f5abb 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -16,7 +16,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2006
- * Copyright (C) Fujitsu, 2012
+ * Copyright (C) 2012 FUJITSU LIMITED
  *
  * Author: Paul McKenney <paulmck@us.ibm.com>
  *	   Lai Jiangshan <laijs@cn.fujitsu.com>
diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index 3318d82..c9f29ea 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -16,7 +16,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2006
- * Copyright (C) Fujitsu, 2012
+ * Copyright (C) 2012 FUJITSU LIMITED
  *
  * Author: Paul McKenney <paulmck@us.ibm.com>
  *	   Lai Jiangshan <laijs@cn.fujitsu.com>
-- 
1.7.1

