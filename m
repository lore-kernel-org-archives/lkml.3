Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaK0UJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:09:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaK0UJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:09:47 -0500
Date: Thu, 27 Nov 2014 22:09:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH v6 20/46] KVM: s390: enable virtio-ccw revision 1
Message-ID: <1417118789-18231-21-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417118789-18231-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Now that virtio-ccw has everything needed to support virtio 1.0 in
place, try to enable it if the host supports it.

MST: enable virtio 1.0 feature bit

Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/s390/kvm/virtio_ccw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 79f6737..8ec68dd 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -103,7 +103,7 @@ struct virtio_rev_info {
 };
 
 /* the highest virtio-ccw revision we support */
-#define VIRTIO_CCW_REV_MAX 0
+#define VIRTIO_CCW_REV_MAX 1
 
 struct virtio_ccw_vq_info {
 	struct virtqueue *vq;
-- 
MST

