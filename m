Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3EFKhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:37:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3EFKho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:37:44 -0400
Date: Mon, 6 May 2013 13:37:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: drop virtio_net.h dependency
Message-ID: <20130506103734.GA12481@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no net specific code in vhost.c anymore,
don't include the virtio_net.h header.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This is on top of Asias' patches, already queued so
just FYI.

 drivers/vhost/vhost.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index de9441a..dcde269 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -13,7 +13,6 @@
 
 #include <linux/eventfd.h>
 #include <linux/vhost.h>
-#include <linux/virtio_net.h>
 #include <linux/mm.h>
 #include <linux/mmu_context.h>
 #include <linux/miscdevice.h>
-- 
MST
