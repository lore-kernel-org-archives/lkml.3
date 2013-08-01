Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3HAKUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:20:25 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4643 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab3HAKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:20:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Aug 2013 03:20:23 -0700
Message-ID: <51FA367B.7020805@nvidia.com>
Date: Thu, 1 Aug 2013 13:20:43 +0300
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 05/27] drivers/gpu/host1x/drm: don't check resource with
 devm_ioremap_resource
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de> <1374602524-3398-6-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1374602524-3398-6-git-send-email-wsa@the-dreams.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2013 21:01, Wolfram Sang wrote:
> diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
> index 01097da..9ffece6 100644
> --- a/drivers/gpu/host1x/drm/hdmi.c
> +++ b/drivers/gpu/host1x/drm/hdmi.c
> @@ -1248,9 +1248,6 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
>  		return err;
>  
>  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!regs)
> -		return -ENXIO;
> -
>  	hdmi->regs = devm_ioremap_resource(&pdev->dev, regs);
>  	if (IS_ERR(hdmi->regs))
>  		return PTR_ERR(hdmi->regs);
> 

Looks good to me.

Reviewed-By: Terje Bergstrom <tbergstrom@nvidia.com>

Terje
