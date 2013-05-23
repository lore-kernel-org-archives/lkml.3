Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3EWDWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264Ab3EWDWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:22:49 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next RFC 1/8] macvlan: switch to use IS_ENABLED()
Date: Thu, 23 May 2013 11:12:26 +0800
Message-Id: <1369278753-2533-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/if_macvlan.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index 84dde1d..e47ad46 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -8,7 +8,7 @@
 #include <net/netlink.h>
 #include <linux/u64_stats_sync.h>
 
-#if defined(CONFIG_MACVTAP) || defined(CONFIG_MACVTAP_MODULE)
+#if IS_ENABLED(CONFIG_MACVTAP)
 struct socket *macvtap_get_socket(struct file *);
 #else
 #include <linux/err.h>
-- 
1.7.1

