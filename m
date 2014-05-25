Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaEYMH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 08:07:28 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:50347 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaEYMH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 08:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <1400817487-27179-1-git-send-email-acourbot@nvidia.com>
References: <1400817487-27179-1-git-send-email-acourbot@nvidia.com>
Date: Sun, 25 May 2014 14:07:26 +0200
Message-ID: <CANq1E4QEix2CzTuwMcK6ONLUVmoLEkThuP7SCFz6-z11xQ1T5w@mail.gmail.com>
Subject: Re: [PATCH] drm/ttm: fix kerneldoc of ttm_bo_create
From: David Herrmann <dh.herrmann@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>, Alexandre Courbot <gnurou@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, May 23, 2014 at 5:58 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> The kerneldoc header of ttm_bo_create() was referring to another
> (nonexisting) function and had a few obsolete or incorrect arguments.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> ---
>  include/drm/ttm/ttm_bo_api.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
> index ee127ec33c60..7526c5bf5610 100644
> --- a/include/drm/ttm/ttm_bo_api.h
> +++ b/include/drm/ttm/ttm_bo_api.h
> @@ -485,13 +485,12 @@ extern int ttm_bo_init(struct ttm_bo_device *bdev,
>                         void (*destroy) (struct ttm_buffer_object *));
>
>  /**
> - * ttm_bo_synccpu_object_init
> + * ttm_bo_create
>   *
>   * @bdev: Pointer to a ttm_bo_device struct.
> - * @bo: Pointer to a ttm_buffer_object to be initialized.
>   * @size: Requested size of buffer object.
>   * @type: Requested type of buffer object.
> - * @flags: Initial placement flags.
> + * @placement: Initial placement.
>   * @page_alignment: Data alignment in pages.
>   * @interruptible: If needing to sleep while waiting for GPU resources,
>   * sleep interruptible.
> --
> 1.9.2
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
