Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaAFQRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:17:40 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35197 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaAFQRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:17:39 -0500
MIME-Version: 1.0
In-Reply-To: <9707c877b8dace786fad32b3fb3b262cf97a02aa.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
	<9707c877b8dace786fad32b3fb3b262cf97a02aa.1389018324.git.rashika.kheria@gmail.com>
Date: Mon, 6 Jan 2014 17:17:37 +0100
Message-ID: <CAMeQTsZ4M7ihF1HpQggkqGgWeEmxDVenFq-xOW9y4biY6Gshyg@mail.gmail.com>
Subject: Re: [PATCH 08/85] drivers: gpu: Mark function as static in cdv_intel_dp.c
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>, josh@joshtriplett.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 4:02 PM, Rashika Kheria <rashika.kheria@gmail.com> wrote:
> Mark function cdv_intel_fixed_panel_mode() as static in
> drm/gma500/cdv_intel_dp.c because it is not used outside this file.
>
> This eliminates the following warning in drm/gma500/cdv_intel_dp.c:
> drivers/gpu/drm/gma500/cdv_intel_dp.c:680:6: warning: no previous prototype for ‘cdv_intel_fixed_panel_mode’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/gpu/drm/gma500/cdv_intel_dp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/gma500/cdv_intel_dp.c b/drivers/gpu/drm/gma500/cdv_intel_dp.c
> index f88a181..36975bd 100644
> --- a/drivers/gpu/drm/gma500/cdv_intel_dp.c
> +++ b/drivers/gpu/drm/gma500/cdv_intel_dp.c
> @@ -677,7 +677,7 @@ cdv_intel_dp_i2c_init(struct gma_connector *connector,
>         return ret;
>  }
>
> -void cdv_intel_fixed_panel_mode(struct drm_display_mode *fixed_mode,
> +static void cdv_intel_fixed_panel_mode(struct drm_display_mode *fixed_mode,
>         struct drm_display_mode *adjusted_mode)
>  {
>         adjusted_mode->hdisplay = fixed_mode->hdisplay;
> --
> 1.7.9.5
>

Pushed to gma500-next

Thanks
Patrik
