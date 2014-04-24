Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaDXUvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:51:07 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62833 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaDXUvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:51:05 -0400
MIME-Version: 1.0
In-Reply-To: <1393873738-27327-1-git-send-email-balbi@ti.com>
References: <1393873738-27327-1-git-send-email-balbi@ti.com>
Date: Thu, 24 Apr 2014 16:51:04 -0400
Message-ID: <CAF6AEGuE2MvN9SrO-R2_DnWtHtxwuFLwH6kUe4vrwcREsG5XDQ@mail.gmail.com>
Subject: Re: [PATCH] drm/tilcdc increase allowable supported resolution
From: Rob Clark <robdclark@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: David Airlie <airlied@linux.ie>, "airlied@redhat.com" <airlied@redhat.com>,
        Benoit Parrot <bparrot@ti.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 2:08 PM, Felipe Balbi <balbi@ti.com> wrote:
> From: Darren Etheridge <detheridge@ti.com>
>
> 1680x1050 appears to also be within the bandwidth capabilities
> of the device and memory infrastructure.

For this one, is 1680x1050 possible on all devices w/ tilcdc (like 1st
gen beaglebone (white), etc)?  If not, maybe better to keep the
default conservative and override the default in devicetree..

BR,
-R

> Signed-off-by: Darren Etheridge <detheridge@ti.com>
> ---
>  drivers/gpu/drm/tilcdc/tilcdc_drv.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.h b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
> index 5bb64e3..b47ec24 100644
> --- a/drivers/gpu/drm/tilcdc/tilcdc_drv.h
> +++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
> @@ -43,7 +43,7 @@
>   * with optimized DDR & EMIF settings tweaked 1920x1080@24 appears to
>   * be supportable
>   */
> -#define TILCDC_DEFAULT_MAX_BANDWIDTH  (1280*1024*60)
> +#define TILCDC_DEFAULT_MAX_BANDWIDTH  (1680*1050*60)
>
>
>  struct tilcdc_drm_private {
> --
> 1.9.0
>
