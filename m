Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaKZL0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:26:48 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54919 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaKZL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:26:40 -0500
MIME-Version: 1.0
In-Reply-To: <1417000478-29940-1-git-send-email-andnlnbn18@gmail.com>
References: <1417000478-29940-1-git-send-email-andnlnbn18@gmail.com>
Date: Wed, 26 Nov 2014 12:26:39 +0100
Message-ID: <CAFLxGvxjFrNj5UY8TFVH5ZS9C-nevntJTQOBge1dPCOgxBWkTA@mail.gmail.com>
Subject: Re: [PATCH] Drivers:staging:speakup: Fixed checkpatch warning
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Athira Lekshmi C V <andnlnbn18@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, domagoj.trsan@gmail.com,
        aysemelikeyurtoglu@gmail.com, speakup@linux-speakup.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 12:14 PM, Athira Lekshmi C V
<andnlnbn18@gmail.com> wrote:
> Fixed the checkpatch warning:
> WARNING: simple_strtoul is obsolete, use kstrtoul instead
>
> Signed-off-by: Athira Lekshmi C V <andnlnbn18@gmail.com>
> ---
>  drivers/staging/speakup/varhandlers.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/speakup/varhandlers.c b/drivers/staging/speakup/varhandlers.c
> index 1b0d1c0..00fd67e 100644
> --- a/drivers/staging/speakup/varhandlers.c
> +++ b/drivers/staging/speakup/varhandlers.c
> @@ -324,7 +324,7 @@ char *spk_s2uchar(char *start, char *dest)
>  {
>         int val = 0;
>
> -       val = simple_strtoul(skip_spaces(start), &start, 10);
> +       val = kstrtoul(skip_spaces(start), &start, 10);
>         if (*start == ',')
>                 start++;
>         *dest = (u_char)val;

NACK.

Please test your patch or at least read the function signature kstrtoul().

-- 
Thanks,
//richard
