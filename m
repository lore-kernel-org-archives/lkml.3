Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaEXHXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:23:55 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56554 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaEXHXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:23:54 -0400
Message-ID: <53804907.7010004@gmail.com>
Date: Sat, 24 May 2014 09:23:51 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Mark Brown <broonie@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: pxa: pxa-ssp: Terminate of match table
References: <1400890613-5704-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1400890613-5704-1-git-send-email-sboyd@codeaurora.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2014 02:16 AM, Stephen Boyd wrote:
> Failure to terminate this match table can lead to boot failures
> depending on where the compiler places the match table.
> 
> Cc: Daniel Mack <zonque@gmail.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Daniel Mack <zonque@gmail.com>


> ---
>  sound/soc/pxa/pxa-ssp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
> index a3119a00d8fa..dd35e7be1d8b 100644
> --- a/sound/soc/pxa/pxa-ssp.c
> +++ b/sound/soc/pxa/pxa-ssp.c
> @@ -810,6 +810,7 @@ static const struct snd_soc_component_driver pxa_ssp_component = {
>  #ifdef CONFIG_OF
>  static const struct of_device_id pxa_ssp_of_ids[] = {
>  	{ .compatible = "mrvl,pxa-ssp-dai" },
> +	{}
>  };
>  #endif
>  
> 

