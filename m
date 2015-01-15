Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbbAONGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:06:51 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:37504 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbbAONGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:06:49 -0500
Date: Thu, 15 Jan 2015 14:06:42 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] virtio_balloon: coding style fixes
Message-ID: <20150115130642.GC7008@dhcp22.suse.cz>
References: <1421321941-21111-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421321941-21111-1-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-01-15 13:39:06, Michael S. Tsirkin wrote:
> Most of our code has
> struct foo {
> }
> 
> Fix two instances where balloon is inconsistent.

I hate to complain but is it really necessary to post such patches to
linux-api?

I thought the list was primarily for API related discussions.
This is not the only mail sent here which doesn't fall into that
category IMO. It is far from low volume list for quite some time.

Please let's get back low volume and API only discussion!

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/uapi/linux/virtio_balloon.h | 3 +--
>  drivers/virtio/virtio_balloon.c     | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> index be40f70..4b0488f 100644
> --- a/include/uapi/linux/virtio_balloon.h
> +++ b/include/uapi/linux/virtio_balloon.h
> @@ -36,8 +36,7 @@
>  /* Size of a PFN in the balloon interface. */
>  #define VIRTIO_BALLOON_PFN_SHIFT 12
>  
> -struct virtio_balloon_config
> -{
> +struct virtio_balloon_config {
>  	/* Number of pages host wants Guest to give up. */
>  	__le32 num_pages;
>  	/* Number of pages we've actually got in balloon. */
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 3176ea4..0413157 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -44,8 +44,7 @@ static int oom_pages = OOM_VBALLOON_DEFAULT_PAGES;
>  module_param(oom_pages, int, S_IRUSR | S_IWUSR);
>  MODULE_PARM_DESC(oom_pages, "pages to free on OOM");
>  
> -struct virtio_balloon
> -{
> +struct virtio_balloon {
>  	struct virtio_device *vdev;
>  	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq;
>  
> -- 
> MST
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
