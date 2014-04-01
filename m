Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaDAMgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:36:07 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:57315 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAMgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:36:05 -0400
MIME-Version: 1.0
In-Reply-To: <1396355585-458-1-git-send-email-jon@ringle.org>
References: <1396355585-458-1-git-send-email-jon@ringle.org>
Date: Tue, 1 Apr 2014 08:36:03 -0400
X-Google-Sender-Auth: wAzWIzkZjSf5b5tupSxyfeG_0TY
Message-ID: <CAMwGMjwmkeET-K7w1tEESS8Ram278aELs0_x+Gt6+Y3j4kLV0Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] video: da8xx-fb: Add support for Densitron 84-0023-001T
From: Jon Ringle <jon@ringle.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fbdev@vger.kernel.org
Cc: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        Jon Ringle <jringle@gridpoint.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 8:33 AM,  <jon@ringle.org> wrote:
> From: Jon Ringle <jringle@gridpoint.com>
>
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  drivers/video/da8xx-fb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
> index e030e17..d042624 100644
> --- a/drivers/video/da8xx-fb.c
> +++ b/drivers/video/da8xx-fb.c
> @@ -243,6 +243,20 @@ static struct fb_videomode known_lcd_panels[] = {
>                 .sync           = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
>                 .flag           = 0,
>         },
> +       [3] = {
> +               /* Densitron 84-0023-001T */
> +               .name           = "Densitron_LCD",

Crap. I'm sorry. I will resend again. with the correct patch with the
name Tomi suggested

Jon
