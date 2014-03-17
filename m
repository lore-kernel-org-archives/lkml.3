Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaCQBjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:39:37 -0400
Received: from ozlabs.org ([203.10.76.45]:53467 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbaCQBjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:39:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Revert a02bbb1ccfe8: MAINTAINERS: add virtio-dev ML for virtio
In-Reply-To: <87ob15tzg3.fsf@rustcorp.com.au>
References: <531F4528.8000402@infradead.org> <87vbvjue71.fsf@rustcorp.com.au> <20140315140017.GA14601@infradead.org> <87ob15tzg3.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 17 Mar 2014 12:09:25 +1030
Message-ID: <87k3bttxgy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OASIS virtio-dev mailing list is a good place for implementers to
discuss details of the standard, but it requires subscription to avoid
IP issues :(

It makes more sense to stick with the
virtualization@lists.linux-foundation.org mailing list for bug
reports.  We can refer to the OASIS list if it involves a question on
the standard itself.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c31ae72af6d..26fc1e18f902 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9385,7 +9385,6 @@ F:	include/media/videobuf2-*
 
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
-L:	virtio-dev@lists.oasis-open.org (subscribers-only)
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/char/virtio_console.c
@@ -9395,7 +9394,6 @@ F:	include/uapi/linux/virtio_console.h
 VIRTIO CORE, NET AND BLOCK DRIVERS
 M:	Rusty Russell <rusty@rustcorp.com.au>
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-L:	virtio-dev@lists.oasis-open.org (subscribers-only)
 L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/virtio/
@@ -9408,7 +9406,6 @@ F:	include/uapi/linux/virtio_*.h
 VIRTIO HOST (VHOST)
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
-L:	virtio-dev@lists.oasis-open.org (subscribers-only)
 L:	virtualization@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 S:	Maintained
