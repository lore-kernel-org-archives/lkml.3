Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaLSBjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:39:09 -0500
Received: from ozlabs.org ([103.22.144.67]:58012 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaLSBiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:38:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/6] tools/virtio: more stubs
In-Reply-To: <1418594542-22623-2-git-send-email-mst@redhat.com>
References: <1418594542-22623-1-git-send-email-mst@redhat.com> <1418594542-22623-2-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 19 Dec 2014 11:58:59 +1030
Message-ID: <87ppbgsa04.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> As usual, add more stubs to fix test build after main
> codebase changes.

This doesn't apply, since:

> diff --git a/tools/virtio/linux/virtio_config.h b/tools/virtio/linux/virtio_config.h
> index dafe1c9..806d683 100644
> --- a/tools/virtio/linux/virtio_config.h
> +++ b/tools/virtio/linux/virtio_config.h
> @@ -1,8 +1,7 @@
>  #include <linux/virtio_byteorder.h>
>  #include <linux/virtio.h>
> +#include <uapi/linux/virtio_config.h>
>  
> -#define VIRTIO_TRANSPORT_F_START	28
> -#define VIRTIO_TRANSPORT_F_END		32
>  /*

Version in master has no headers in this file.

What's this based on?

Thanks,
Rusty.
