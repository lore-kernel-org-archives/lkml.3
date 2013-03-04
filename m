Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3CDMVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:21:12 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55400 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3CDMVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:21:11 -0500
MIME-Version: 1.0
In-Reply-To: <1361306033-22229-1-git-send-email-maxin.john@gmail.com>
References: <1361306033-22229-1-git-send-email-maxin.john@gmail.com>
Date: Mon, 4 Mar 2013 13:21:06 +0100
Message-ID: <CAMhs6YyvRwfkEubi_7BJvU6rvqw6hcboWtJTsJ2DGfrnzbhHcA@mail.gmail.com>
Subject: Re: [PATCH] dma: timb_dma: Fix compiler warning
From: "Maxin B. John" <maxin.john@gmail.com>
To: djbw@fb.com, lars@metafoo.de
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        "Maxin B. John" <maxin.john@enea.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 9:33 PM,  <maxin.john@gmail.com> wrote:
> From: "Maxin B. John" <maxin.john@enea.com>
>
> Fix this compiler warning:
> warning: 'td_remove' defined but not used [-Wunused-function]
>
> Signed-off-by: Maxin B. John <maxin.john@enea.com>
> ---
>  drivers/dma/timb_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
> index 952f823..26107ba 100644
> --- a/drivers/dma/timb_dma.c
> +++ b/drivers/dma/timb_dma.c
> @@ -823,7 +823,7 @@ static struct platform_driver td_driver = {
>                 .owner  = THIS_MODULE,
>         },
>         .probe  = td_probe,
> -       .remove = __exit_p(td_remove),
> +       .remove = td_remove,
>  };
>
>  module_platform_driver(td_driver);
> --
> 1.7.7
>

ping..
