Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaGUJcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:32:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbaGUJcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:32:20 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amos Kong <akong@redhat.com>, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 1/3] virtio: rng: remove unused struct element
Date: Mon, 21 Jul 2014 15:00:59 +0530
Message-Id: <4895429ba7a3cca4622f2fcf28fbbd40d1aca401.1405934853.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405934853.git.amit.shah@redhat.com>
References: <cover.1405934853.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405934853.git.amit.shah@redhat.com>
References: <cover.1405934853.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vdev is unused in struct virtrng_info, remove it.

CC: Amos Kong <akong@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index e9b15bc..d8ffebd 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -28,7 +28,6 @@
 static DEFINE_IDA(rng_index_ida);
 
 struct virtrng_info {
-	struct virtio_device *vdev;
 	struct hwrng hwrng;
 	struct virtqueue *vq;
 	unsigned int data_avail;
-- 
1.9.3

