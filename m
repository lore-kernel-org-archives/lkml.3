Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaJTJSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:18:01 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:63367 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbaJTJR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:17:59 -0400
Message-ID: <1413796676.16435.9.camel@x220>
Subject: [PATCH] virtio: Fix comment typo 'CONFIG_S_FAILED'
From: Paul Bolle <pebolle@tiscali.nl>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 20 Oct 2014 11:17:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2014 09:17:56.0616 (UTC) FILETIME=[BC2FF880:01CFEC46]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the VIRTIO_ prefix CONFIG_S_FAILED looks like a Kconfig macro.
So use that prefix here too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Introduced in commit c6716bae52f9 ("virtio-pci: move freeze/restore to
virtio core").

Tested with "git grep" only.

 include/linux/virtio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 65261a7244fc..abafae783058 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -78,7 +78,7 @@ bool virtqueue_is_broken(struct virtqueue *vq);
 /**
  * virtio_device - representation of a device using virtio
  * @index: unique position on the virtio bus
- * @failed: saved value for CONFIG_S_FAILED bit (for restore)
+ * @failed: saved value for VIRTIO_CONFIG_S_FAILED bit (for restore)
  * @config_enabled: configuration change reporting enabled
  * @config_change_pending: configuration change reported while disabled
  * @config_lock: protects configuration change reporting
-- 
1.9.3

