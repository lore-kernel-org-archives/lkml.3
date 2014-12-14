Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaLNWFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:05:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:46140 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbaLNWEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:04:49 -0500
Date: Mon, 15 Dec 2014 00:04:43 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 6/6] tools/virtio: add virtio 1.0 in vringh_test
Message-ID: <1418594542-22623-7-git-send-email-mst@redhat.com>
References: <1418594542-22623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418594542-22623-1-git-send-email-mst@redhat.com>
X-Mailer: git-send-email 2.0.0.545.gd9cabeb
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/vringh_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index 51d922f..5f94f51 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -457,6 +457,8 @@ int main(int argc, char *argv[])
 			__virtio_set_bit(&vdev, VIRTIO_RING_F_INDIRECT_DESC);
 		else if (strcmp(argv[1], "--eventidx") == 0)
 			__virtio_set_bit(&vdev, VIRTIO_RING_F_EVENT_IDX);
+		else if (strcmp(argv[1], "--virtio-1") == 0)
+			__virtio_set_bit(&vdev, VIRTIO_F_VERSION_1);
 		else if (strcmp(argv[1], "--slow-range") == 0)
 			getrange = getrange_slow;
 		else if (strcmp(argv[1], "--fast-vringh") == 0)
-- 
MST

