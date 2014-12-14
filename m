Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaLNWEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:04:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:46056 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaLNWE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:04:29 -0500
Date: Mon, 15 Dec 2014 00:04:23 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 2/6] tools/virtio: fix vringh test
Message-ID: <1418594542-22623-3-git-send-email-mst@redhat.com>
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

Include missing virtio_config.h

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/vringh_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index 9d4b1bc..13e0a76 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -7,6 +7,7 @@
 #include <linux/virtio.h>
 #include <linux/vringh.h>
 #include <linux/virtio_ring.h>
+#include <linux/virtio_config.h>
 #include <linux/uaccess.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-- 
MST

