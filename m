Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965553Ab3FTLyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:54:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965189Ab3FTLyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:54:37 -0400
Date: Thu, 20 Jun 2013 14:55:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Asias He <asias@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC] vhost-net: make more functions static
Message-ID: <20130620115519.GA5301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make two more functions static - they only have local callers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Will be merged through the vhost tree - no need to apply
directly.

 drivers/vhost/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 534adb0..4c5de87 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -167,7 +167,7 @@ static void vhost_net_clear_ubuf_info(struct vhost_net *n)
 	}
 }
 
-int vhost_net_set_ubuf_info(struct vhost_net *n)
+static int vhost_net_set_ubuf_info(struct vhost_net *n)
 {
 	bool zcopy;
 	int i;
@@ -188,7 +188,7 @@ err:
 	return -ENOMEM;
 }
 
-void vhost_net_vq_reset(struct vhost_net *n)
+static void vhost_net_vq_reset(struct vhost_net *n)
 {
 	int i;
 
-- 
MST
