Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaKYQn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:43:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaKYQnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:43:25 -0500
Date: Tue, 25 Nov 2014 18:43:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v4 24/42] virtio_net: enable v1.0 support
Message-ID: <1416933600-21398-25-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416933600-21398-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have completed 1.0 support, enable it in our driver.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a0e64cf..c6a72d3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2003,6 +2003,7 @@ static unsigned int features[] = {
 	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ,
 	VIRTIO_NET_F_CTRL_MAC_ADDR,
 	VIRTIO_F_ANY_LAYOUT,
+	VIRTIO_F_VERSION_1,
 };
 
 static struct virtio_driver virtio_net_driver = {
-- 
MST

