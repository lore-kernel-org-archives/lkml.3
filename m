Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaLAJSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:18:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaLAJSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:18:38 -0500
Date: Mon, 1 Dec 2014 11:18:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next] vhost: remove unnecessary forward declarations
 in vhost.h
Message-ID: <20141201091833.GA15607@redhat.com>
References: <1417070481-10331-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417070481-10331-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 02:41:21PM +0800, Jason Wang wrote:
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks.

> ---
>  drivers/vhost/vhost.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 3eda654..7d039ef 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -12,8 +12,6 @@
>  #include <linux/virtio_ring.h>
>  #include <linux/atomic.h>
>  
> -struct vhost_device;
> -
>  struct vhost_work;
>  typedef void (*vhost_work_fn_t)(struct vhost_work *work);
>  
> @@ -54,8 +52,6 @@ struct vhost_log {
>  	u64 len;
>  };
>  
> -struct vhost_virtqueue;
> -
>  /* The virtqueue structure describes a queue attached to a device. */
>  struct vhost_virtqueue {
>  	struct vhost_dev *dev;
> -- 
> 1.9.1
