Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3GHCWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 22:22:17 -0400
Received: from ozlabs.org ([203.10.76.45]:45140 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab3GHCWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:22:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add tools/virtio/ under virtio
In-Reply-To: <20130707143238.GA3059@redhat.com>
References: <20130707143238.GA3059@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 08 Jul 2013 11:32:25 +0930
Message-ID: <87ip0lerm6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> This should help make sure patches go to the correct list.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Indeed.  Thanks.

Applied,
Rusty.

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ad7e322..66172fc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8800,6 +8800,7 @@ M:	"Michael S. Tsirkin" <mst@redhat.com>
>  L:	virtualization@lists.linux-foundation.org
>  S:	Maintained
>  F:	drivers/virtio/
> +F:	tools/virtio/
>  F:	drivers/net/virtio_net.c
>  F:	drivers/block/virtio_blk.c
>  F:	include/linux/virtio_*.h
> -- 
> MST
