Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3HAIw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:52:59 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:59527 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3HAIw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:52:58 -0400
Date: Thu, 1 Aug 2013 09:52:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Peter Tyser'" <ptyser@xes-inc.com>
Subject: Re: [PATCH] mfd: lpc_ich: Staticize struct 'lpc_chipset_info'
Message-ID: <20130801085252.GO13298@lee--X1>
References: <002d01ce8e5a$b73e3030$25ba9090$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <002d01ce8e5a$b73e3030$25ba9090$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Aug 2013, Jingoo Han wrote:

> 'lpc_chipset_info' is used only in this file.
> 
> Fix the following sparse warning:
> 
> drivers/mfd/lpc_ich.c:216:21: warning: symbol 'lpc_chipset_info' was not declared. Should it be static?
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/lpc_ich.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
> index 2403332..9483bc8 100644
> --- a/drivers/mfd/lpc_ich.c
> +++ b/drivers/mfd/lpc_ich.c
> @@ -213,7 +213,7 @@ enum lpc_chipsets {
>  	LPC_COLETO,	/* Coleto Creek */
>  };
>  
> -struct lpc_ich_info lpc_chipset_info[] = {
> +static struct lpc_ich_info lpc_chipset_info[] = {
>  	[LPC_ICH] = {
>  		.name = "ICH",
>  		.iTCO_version = 1,

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
