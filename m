Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaBGGSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 01:18:09 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9462 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaBGGSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 01:18:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Feb 2014 22:16:32 -0800
Message-ID: <52F47A9B.1060204@nvidia.com>
Date: Fri, 7 Feb 2014 15:18:03 +0900
From: jinyoungp <jinyoungp@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Thunderbird/27.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/12] backlight: aat2870: Remove unnecessary OOM messages
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com> <000201cf2313$b65183e0$22f48ba0$%han@samsung.com>
In-Reply-To: <000201cf2313$b65183e0$22f48ba0$%han@samsung.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="EUC-KR"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jinyoung Park <jinyoungp@nvidia.com>

On 02/06/2014 05:16 PM, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/aat2870_bl.c |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
> index ee0c0a9..ec5350f 100644
> --- a/drivers/video/backlight/aat2870_bl.c
> +++ b/drivers/video/backlight/aat2870_bl.c
> @@ -149,8 +149,6 @@ static int aat2870_bl_probe(struct platform_device *pdev)
>  				  sizeof(struct aat2870_bl_driver_data),
>  				  GFP_KERNEL);
>  	if (!aat2870_bl) {
> -		dev_err(&pdev->dev,
> -			"Failed to allocate memory for aat2870 backlight\n");
>  		ret = -ENOMEM;
>  		goto out;
>  	}

