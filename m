Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3EWDXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264Ab3EWDXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:23:02 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next RFC 4/8] macvlan: reduce the max number of taps to 8
Date: Thu, 23 May 2013 11:12:29 +0800
Message-Id: <1369278753-2533-5-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be same with tap.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/if_macvlan.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index e47ad46..32e943a 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -50,7 +50,7 @@ struct macvlan_pcpu_stats {
  * Maximum times a macvtap device can be opened. This can be used to
  * configure the number of receive queue, e.g. for multiqueue virtio.
  */
-#define MAX_MACVTAP_QUEUES	(NR_CPUS < 16 ? NR_CPUS : 16)
+#define MAX_MACVTAP_QUEUES	8
 
 #define MACVLAN_MC_FILTER_BITS	8
 #define MACVLAN_MC_FILTER_SZ	(1 << MACVLAN_MC_FILTER_BITS)
-- 
1.7.1

