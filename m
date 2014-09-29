Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaI2I44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:56:56 -0400
Received: from smtp-out-039.synserver.de ([212.40.185.39]:1028 "EHLO
	smtp-out-039.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaI2I4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:56:55 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7709
Message-ID: <54291EE4.7030505@metafoo.de>
Date: Mon, 29 Sep 2014 10:57:08 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        linux-kernel@vger.kernel.org
CC: alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 2/2] ASoC: ssm2602: add support for 11.025kHz and 22.5kHz
 sample rates
References: <1411891105-22683-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1411891105-22683-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2014 09:58 AM, Stefan Kristiansson wrote:
> This adds the necessary values to the constraint list and
> register values to the coefficient table in order to
> configure the device for 11.025kHz and 22.5kHz sample rates.
>
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

But again, don't forget to Cc the ASoC maintainers, otherwise the patch will 
be lost.

[...]
> @@ -467,7 +477,8 @@ static int ssm2602_set_bias_level(struct snd_soc_codec *codec,
>   	return 0;
>   }
>
> -#define SSM2602_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000 |\
> +#define SSM2602_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
> +		SNDRV_PCM_RATE_22050 | SNDRV_PCM_RATE_16000 |\

Tiny nitpick, order should be SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_22050 to 
keep things sorted.

>   		SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 |\
>   		SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_88200 |\
>   		SNDRV_PCM_RATE_96000)
>

