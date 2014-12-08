Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaLHNJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:09:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbaLHNGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:19 -0500
Date: Mon, 8 Dec 2014 15:06:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dahi@linux.vnet.ibm.com, cornelia.huck@de.ibm.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 5/6] virtio_balloon: drop legacy_only driver flag
Message-ID: <1418042769-25539-6-git-send-email-mst@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418042769-25539-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we have blacklisted balloon in core, no need
for a driver flag.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 4497def..c9703d4 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -518,7 +518,6 @@ static unsigned int features[] = {
 };
 
 static struct virtio_driver virtio_balloon_driver = {
-	.legacy_only = true,
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
-- 
MST

