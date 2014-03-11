Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaCKRRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:17:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59916 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbaCKRRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:17:32 -0400
Message-ID: <531F4528.8000402@infradead.org>
Date: Tue, 11 Mar 2014 10:17:28 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: virtio-dev is subscribers only
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

virtio-dev mailing list is for subscribers only according to the
returned message after trying to send to it.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- mmotm-2014-0310-1535.orig/MAINTAINERS
+++ mmotm-2014-0310-1535/MAINTAINERS
@@ -9438,7 +9438,7 @@ F:	include/media/videobuf2-*
 
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
-L:	virtio-dev@lists.oasis-open.org
+L:	virtio-dev@lists.oasis-open.org (subscribers-only)
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/char/virtio_console.c
@@ -9448,7 +9448,7 @@ F:	include/uapi/linux/virtio_console.h
 VIRTIO CORE, NET AND BLOCK DRIVERS
 M:	Rusty Russell <rusty@rustcorp.com.au>
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-L:	virtio-dev@lists.oasis-open.org
+L:	virtio-dev@lists.oasis-open.org (subscribers-only)
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/virtio/
@@ -9461,7 +9461,7 @@ F:	include/uapi/linux/virtio_*.h
 VIRTIO HOST (VHOST)
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
-L:	virtio-dev@lists.oasis-open.org
+L:	virtio-dev@lists.oasis-open.org (subscribers-only)
 L:	virtualization@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 S:	Maintained
