Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaFTPRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:17:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbaFTPRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:17:45 -0400
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH] trivial: fix spelling of synchronize_rcu in comments
To: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 20 Jun 2014 17:19:06 +0200
Message-ID: <20140620151850.32751.6017.stgit@dragon>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---

 include/linux/percpu-refcount.h |    2 +-
 net/rds/af_rds.c                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 95961f0..9e833d5 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -29,7 +29,7 @@
  * calls io_destroy() or the process exits.
  *
  * In the aio code, kill_ioctx() is called when we wish to destroy a kioctx; it
- * calls percpu_ref_kill(), then hlist_del_rcu() and sychronize_rcu() to remove
+ * calls percpu_ref_kill(), then hlist_del_rcu() and synchronize_rcu() to remove
  * the kioctx from the proccess's list of kioctxs - after that, there can't be
  * any new users of the kioctx (from lookup_ioctx()) and it's then safe to drop
  * the initial ref with percpu_ref_put().
diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 424ff62..1044337 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -83,7 +83,7 @@ static int rds_release(struct socket *sock)
 
 	/*
 	 * the binding lookup hash uses rcu, we need to
-	 * make sure we sychronize_rcu before we free our
+	 * make sure we synchronize_rcu before we free our
 	 * entry
 	 */
 	rds_remove_bound(rs);

