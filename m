Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaCMDWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 23:22:21 -0400
Received: from ozlabs.org ([203.10.76.45]:55744 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbaCMDWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 23:22:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: virtio-dev is subscribers only
In-Reply-To: <531F4528.8000402@infradead.org>
References: <531F4528.8000402@infradead.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 13 Mar 2014 11:06:50 +1030
Message-ID: <87vbvjue71.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> virtio-dev mailing list is for subscribers only according to the
> returned message after trying to send to it.

Thanks, applied.

Cheers,
Rusty.

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  MAINTAINERS |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> --- mmotm-2014-0310-1535.orig/MAINTAINERS
> +++ mmotm-2014-0310-1535/MAINTAINERS
> @@ -9438,7 +9438,7 @@ F:	include/media/videobuf2-*
>  
>  VIRTIO CONSOLE DRIVER
>  M:	Amit Shah <amit.shah@redhat.com>
> -L:	virtio-dev@lists.oasis-open.org
> +L:	virtio-dev@lists.oasis-open.org (subscribers-only)
>  L:	virtualization@lists.linux-foundation.org
>  S:	Maintained
>  F:	drivers/char/virtio_console.c
> @@ -9448,7 +9448,7 @@ F:	include/uapi/linux/virtio_console.h
>  VIRTIO CORE, NET AND BLOCK DRIVERS
>  M:	Rusty Russell <rusty@rustcorp.com.au>
>  M:	"Michael S. Tsirkin" <mst@redhat.com>
> -L:	virtio-dev@lists.oasis-open.org
> +L:	virtio-dev@lists.oasis-open.org (subscribers-only)
>  L:	virtualization@lists.linux-foundation.org
>  S:	Maintained
>  F:	drivers/virtio/
> @@ -9461,7 +9461,7 @@ F:	include/uapi/linux/virtio_*.h
>  VIRTIO HOST (VHOST)
>  M:	"Michael S. Tsirkin" <mst@redhat.com>
>  L:	kvm@vger.kernel.org
> -L:	virtio-dev@lists.oasis-open.org
> +L:	virtio-dev@lists.oasis-open.org (subscribers-only)
>  L:	virtualization@lists.linux-foundation.org
>  L:	netdev@vger.kernel.org
>  S:	Maintained
