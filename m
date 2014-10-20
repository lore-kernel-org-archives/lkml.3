Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaJTWNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:13:43 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:39150 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaJTWNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:13:42 -0400
MIME-Version: 1.0
In-Reply-To: <20141016093734.GA2563@kaos.lebenslange-mailadresse.de>
References: <20141016093734.GA2563@kaos.lebenslange-mailadresse.de>
Date: Mon, 20 Oct 2014 18:13:22 -0400
Message-ID: <CADnq5_NdUux-U1QvN2PHCq3+97uMe8YVqw_0c3qkvExmYrhb+g@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] radeon: clean up coding style differences in radeon_get_bios()
From: Alex Deucher <alexdeucher@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 5:37 AM, Wilfried Klaebe
<w-lkml@lebenslange-mailadresse.de> wrote:
> radeon: clean up coding style differences in radeon_get_bios()
>
> Signed-off-by: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>

Applied.  thanks!

Alex

>
> diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
> index 6a03624..63ccb8f 100644
> --- a/drivers/gpu/drm/radeon/radeon_bios.c
> +++ b/drivers/gpu/drm/radeon/radeon_bios.c
> @@ -658,12 +658,10 @@ bool radeon_get_bios(struct radeon_device *rdev)
>                 r = igp_read_bios_from_vram(rdev);
>         if (r == false)
>                 r = radeon_read_bios(rdev);
> -       if (r == false) {
> +       if (r == false)
>                 r = radeon_read_disabled_bios(rdev);
> -       }
> -       if (r == false) {
> +       if (r == false)
>                 r = radeon_read_platform_bios(rdev);
> -       }
>         if (r == false || rdev->bios == NULL) {
>                 DRM_ERROR("Unable to locate a BIOS ROM\n");
>                 rdev->bios = NULL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
