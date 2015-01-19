Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbbASNy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:54:58 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:44667 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbbASNy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:54:57 -0500
Message-ID: <54BD0CA5.4070207@lysator.liu.se>
Date: Mon, 19 Jan 2015 14:54:45 +0100
From: Peter Rosin <peda@lysator.liu.se>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Mark Brown <broonie@kernel.org>, nicolas.ferre@atmel.com,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ASoC: atmel_ssc_dai: remove clock pin comments
In-Reply-To: <1421392784-32298-2-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As the clock can be get from TK/RK pin, so remove the comments.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>  sound/soc/atmel/atmel_ssc_dai.c | 4 ----
>  1 file changed, 4 deletions(-)
> diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
> index e691aab..198661b 100644
> --- a/sound/soc/atmel/atmel_ssc_dai.c
> +++ b/sound/soc/atmel/atmel_ssc_dai.c
> @@ -452,10 +452,6 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
>  	case SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBM_CFM:
>  		/*
>  		 * I2S format, CODEC supplies BCLK and LRC clocks.
> -		 *
> -		 * The SSC transmit clock is obtained from the BCLK signal on
> -		 * on the TK line, and the SSC receive clock is
> -		 * generated from the transmit clock.
>  		 */
>  		rcmr =	  SSC_BF(RCMR_PERIOD, 0)
>  			| SSC_BF(RCMR_STTDLY, START_DELAY)
> -- 
> 2.3.0.rc0

Hi!

You should probably remove that comment from the case with
SND_SOC_DAIFMT_DSP_A | SND_SOC_DAIFMT_CBM_CFM as well...

Cheers,
Peter

