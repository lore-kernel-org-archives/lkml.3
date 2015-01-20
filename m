Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbbATMfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:35:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbbATMfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:35:32 -0500
Date: Tue, 20 Jan 2015 14:35:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Shah <amit.shah@redhat.com>, Amos Kong <akong@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-crypto@vger.kernel.org
Subject: [PATCH repost] virtio_rng: drop extra empty line
Message-ID: <20150120123515.GA28318@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

makes code look a bit prettier.

Cc: linux-crypto@vger.kernel.org.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 72295ea..3fa2f8a 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -39,7 +39,6 @@ struct virtrng_info {
 	bool hwrng_removed;
 };
 
-
 static void random_recv_done(struct virtqueue *vq)
 {
 	struct virtrng_info *vi = vq->vdev->priv;
-- 
MST
