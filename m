Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3EaKDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:03:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab3EaKDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:03:48 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next rfc V2 2/8] macvlan: switch to use IS_ENABLED()
Date: Fri, 31 May 2013 17:53:19 +0800
Message-Id: <1369994005-5943-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369994005-5943-1-git-send-email-jasowang@redhat.com>
References: <1369994005-5943-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Michael S. Tsirkin <mst@redhat.com>
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

