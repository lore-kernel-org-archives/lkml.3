Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3IYFkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 01:40:14 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45193 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3IYFkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 01:40:03 -0400
Date: Wed, 25 Sep 2013 14:40:00 +0900
From: Simon Horman <horms@verge.net.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, openezx-devel@lists.openezx.org,
        linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] ARM: shmobile: Initialize PWM backlight
 enable_gpio field
Message-ID: <20130925053957.GF1916@verge.net.au>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <1379972467-11243-7-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379972467-11243-7-git-send-email-treding@nvidia.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 11:41:03PM +0200, Thierry Reding wrote:
> The GPIO API defines 0 as being a valid GPIO number, so this field needs
> to be initialized explicitly.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  arch/arm/mach-shmobile/board-armadillo800eva.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
> index 7f8f607..6ccb854 100644
> --- a/arch/arm/mach-shmobile/board-armadillo800eva.c
> +++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
> @@ -423,6 +423,7 @@ static struct platform_pwm_backlight_data pwm_backlight_data = {
>  	.max_brightness = 255,
>  	.dft_brightness = 255,
>  	.pwm_period_ns = 33333, /* 30kHz */
> +	.enable_gpio = -1,
>  };
>  
>  static struct platform_device pwm_backlight_device = {

Acked-by: Simon Horman <horms+renesas@verge.net.au>

