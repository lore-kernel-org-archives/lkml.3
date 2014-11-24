Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaKXOS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:18:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54154 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbaKXOS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:18:27 -0500
Date: Mon, 24 Nov 2014 14:18:18 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lee.jones@linaro.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/6] regulator: arizona-micsupp: Add
	support for WM8280/WM8281
Message-ID: <20141124141807.GA17985@opensource.wolfsonmicro.com>
References: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com> <1415901046-3391-4-git-send-email-rf@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415901046-3391-4-git-send-email-rf@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 05:50:43PM +0000, Richard Fitzgerald wrote:
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/arizona-micsupp.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
> index ce9aca5..4ff55e1 100644
> --- a/drivers/regulator/arizona-micsupp.c
> +++ b/drivers/regulator/arizona-micsupp.c
> @@ -245,6 +245,7 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
>  	 */
>  	switch (arizona->type) {
>  	case WM5110:
> +	case WM8280:
>  		desc = &arizona_micsupp_ext;
>  		micsupp->init_data = arizona_micsupp_ext_default;
>  		break;
> -- 
> 1.7.2.5
> 


Mark - if this patch is ok with you could you ack it so Lee can merge in
this series? Thanks.


> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
