Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaL0XkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 18:40:12 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:64080 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaL0XkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 18:40:10 -0500
MIME-Version: 1.0
In-Reply-To: <1419694644-2241-1-git-send-email-fabf@skynet.be>
References: <1419694644-2241-1-git-send-email-fabf@skynet.be>
Date: Sun, 28 Dec 2014 00:40:08 +0100
Message-ID: <CAMeQTsY5TWRbCP3T1L69JjSL8SimSOo0+3VTzT4oMV1XA3ogDQ@mail.gmail.com>
Subject: Re: [PATCH 1/1 linux-next] drm/gma500: replace 0 by NULL for pointer
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 4:37 PM, Fabian Frederick <fabf@skynet.be> wrote:
> Fix sparse warning:
> drivers/gpu/drm/gma500/psb_drv.c:
> 328:56: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

> ---
>  drivers/gpu/drm/gma500/psb_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
> index 92e7e57..9b49c155 100644
> --- a/drivers/gpu/drm/gma500/psb_drv.c
> +++ b/drivers/gpu/drm/gma500/psb_drv.c
> @@ -325,7 +325,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long flags)
>         if (ret)
>                 goto out_err;
>
> -       dev_priv->mmu = psb_mmu_driver_init(dev, 1, 0, 0);
> +       dev_priv->mmu = psb_mmu_driver_init(dev, 1, 0, NULL);
>         if (!dev_priv->mmu)
>                 goto out_err;
>
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
