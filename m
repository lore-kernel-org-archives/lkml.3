Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbbANBsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:48:05 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:25741 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbbANBsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:48:04 -0500
Message-ID: <54B5CA76.3060608@atmel.com>
Date: Wed, 14 Jan 2015 09:46:30 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Asoc: sam9x5_wm8731: depend on ARCH_AT91 instead of SOC_AT91SAM9X5
References: <1421152046-20069-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421152046-20069-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre Belloni,

On 01/13/2015 08:27 PM, Alexandre Belloni wrote:
> The SOC_AT91SAM9X5 option is going to be removed, only depend on ARCH_AT91 like
> for the other drivers.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Bo Shen <voice.shen@atmel.com>

> ---
>   sound/soc/atmel/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
> index fb3878312bf8..1579e994acf8 100644
> --- a/sound/soc/atmel/Kconfig
> +++ b/sound/soc/atmel/Kconfig
> @@ -45,7 +45,7 @@ config SND_ATMEL_SOC_WM8904
>
>   config SND_AT91_SOC_SAM9X5_WM8731
>   	tristate "SoC Audio support for WM8731-based at91sam9x5 board"
> -	depends on ATMEL_SSC && SND_ATMEL_SOC && SOC_AT91SAM9X5
> +	depends on ARCH_AT91 && ATMEL_SSC && SND_ATMEL_SOC
>   	select SND_ATMEL_SOC_SSC
>   	select SND_ATMEL_SOC_DMA
>   	select SND_SOC_WM8731
>

Best Regards
Bo Shen
