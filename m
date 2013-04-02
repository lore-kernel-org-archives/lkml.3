Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796Ab3DBM5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:57:20 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35256 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760414Ab3DBM5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:57:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130313081955.GA19276@udknight>
References: <20130313081955.GA19276@udknight>
Date: Tue, 2 Apr 2013 14:57:16 +0200
Message-ID: <CAMeQTsaDOYE5VV9vapJyx1FQ-=YX--OFY3nyqZux=0dnH00s8A@mail.gmail.com>
Subject: Re: [PATCH]gma500: remove unused drm_psb_no_fb
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Wang YanQing <udknight@gmail.com>, airlied@linux.ie, airlied@redhat.com,
        alan@linux.intel.com, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 9:19 AM, Wang YanQing <udknight@gmail.com> wrote:
> commit f9f23a77f07506a32d9dc1d925bf85c0e7507b66(gma500: remove no_fb bits)
> remove all the drm_psb_no_fb relations code in gma500 except this line code,
> so remove it also.
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  drivers/gpu/drm/gma500/psb_drv.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/gma500/psb_drv.h b/drivers/gpu/drm/gma500/psb_drv.h
> index a7fd6c4..6053b8a 100644
> --- a/drivers/gpu/drm/gma500/psb_drv.h
> +++ b/drivers/gpu/drm/gma500/psb_drv.h
> @@ -876,7 +876,6 @@ extern const struct psb_ops cdv_chip_ops;
>  #define PSB_D_MSVDX   (1 << 9)
>  #define PSB_D_TOPAZ   (1 << 10)
>
> -extern int drm_psb_no_fb;
>  extern int drm_idle_check_interval;
>
>  /*
> --
> 1.7.12.4.dirty
> --

Your patch has been applied to:
https://github.com/patjak/drm-gma500.git gma500-next

Thanks
Patrik Jakobsson
