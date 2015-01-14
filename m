Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbbANRcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:32:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbbANR1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:27:34 -0500
Date: Wed, 14 Jan 2015 19:27:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: [PATCH v3 01/16] virtio_pci: drop virtio_config dependency
Message-ID: <1421256142-11512-2-git-send-email-mst@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421256142-11512-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_pci does not depend on virtio_config:
let's not include it, users can pull it in as necessary.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 35b552c..509d630 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -39,7 +39,7 @@
 #ifndef _LINUX_VIRTIO_PCI_H
 #define _LINUX_VIRTIO_PCI_H
 
-#include <linux/virtio_config.h>
+#include <linux/types.h>
 
 #ifndef VIRTIO_PCI_NO_LEGACY
 
-- 
MST

