Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaK3NCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 08:02:47 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:54413 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaK3NCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 08:02:45 -0500
MIME-Version: 1.0
In-Reply-To: <1417314256-2962-1-git-send-email-xerofoify@gmail.com>
References: <1417314256-2962-1-git-send-email-xerofoify@gmail.com>
Date: Sun, 30 Nov 2014 14:02:44 +0100
Message-ID: <CAMeQTsaOOMmw1ECZ+KZN8iyGB3ePFjAU_H55E2LRooexKOnijg@mail.gmail.com>
Subject: Re: [PATCH] drivers:gpu:drm Remove unneeded struct of type
 psb_intel_i2c_chan in the header file psb_drv.h
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Arthur Borsboom <arthurborsboom@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 3:24 AM, Nicholas Krause <xerofoify@gmail.com> wrote:
> Removes unneeeded struct *lvds_i2c_bus of type, psb_intel_i2c_chan as this struct
> is no needed due to never being used in the header file, psb_drv.h and therefore
> should be removed from this header file.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

The lvds_i2c_bus is in use and can't be removed. Please at least compile test
your patches before submitting them.

Cheers
Patrik

> ---
>  drivers/gpu/drm/gma500/psb_drv.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/gma500/psb_drv.h b/drivers/gpu/drm/gma500/psb_drv.h
> index 55ebe2b..fc74518 100644
> --- a/drivers/gpu/drm/gma500/psb_drv.h
> +++ b/drivers/gpu/drm/gma500/psb_drv.h
> @@ -522,7 +522,6 @@ struct drm_psb_private {
>         struct drm_display_mode *sdvo_lvds_vbt_mode;
>
>         struct bdb_lvds_backlight *lvds_bl; /* LVDS backlight info from VBT */
> -       struct psb_intel_i2c_chan *lvds_i2c_bus; /* FIXME: Remove this? */
>
>         /* Feature bits from the VBIOS */
>         unsigned int int_tv_support:1;
> --
> 2.1.0
>
