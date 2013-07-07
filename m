Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3GGOba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 10:31:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab3GGOb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 10:31:29 -0400
Date: Sun, 7 Jul 2013 17:32:38 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: [PATCH] MAINTAINERS: add tools/virtio/ under virtio
Message-ID: <20130707143238.GA3059@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should help make sure patches go to the correct list.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ad7e322..66172fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8800,6 +8800,7 @@ M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/virtio/
+F:	tools/virtio/
 F:	drivers/net/virtio_net.c
 F:	drivers/block/virtio_blk.c
 F:	include/linux/virtio_*.h
-- 
MST
