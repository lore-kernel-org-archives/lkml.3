Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaJ1EiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:38:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33745 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaJ1EiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:38:13 -0400
X-AuditID: cbfee68e-f79b46d000002b74-bc-544f1db3482f
Message-id: <544F1DB3.9050204@samsung.com>
Date: Tue, 28 Oct 2014 13:38:11 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Chanho Min <chanho.min@lge.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        HyoJun Im <hyojun.im@lge.com>, gunho.lee@lge.com,
        Hankyung Yu <hankyung.yu@lge.com>, CPGS <cpgs@samsung.com>
Subject: Re: [PATCH] mmc:core: fix hs400 timing selection
References: <1413946555-1266-1-git-send-email-chanho.min@lge.com>
In-reply-to: <1413946555-1266-1-git-send-email-chanho.min@lge.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkUHezrH+IwerzBhYfr11gt5hweTuj
	xctDmhYXpi1kttj3fgqjxefrTewWN361sVpc3jWHzeLI/35Giw/3LzJbHF8b7sDt0fX2CpPH
	nWt72DxuvFrI5NG3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZ7383shfsEK5o37yLsYFxDX8X
	IyeHhICJxM/Zq5ggbDGJC/fWs3UxcnEICSxllFg8bRpzFyMHWNGxuYIgNUIC0xklvm/Nh6h5
	zSix7PpGVpAaXgEtiY57PiA1LAKqEkdX7mUGsdkEdCS2fzsONl9UIEziUNs8MJtXQFDix+R7
	LCBzRAR2MUpcWPgRLMEssBZo8QItEFtYwFKi/+YWdojFjhLHJqwEG8op4CQx7+gxqHodif2t
	09ggbHmJzWveMkM885JdonONHsRBAhLfJh9igfhFVmLTAagSSYmDK26wTGAUm4XkpFlIps5C
	MnUBI/MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMC4PP3vWd8OxpsHrA8xCnAwKvHwGjz0
	CxFiTSwrrsw9xGgKdMVEZinR5Hxg9OeVxBsamxlZmJqYGhuZW5opifMmSP0MFhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cDII2sn2JFU9v24uVOESeaOT+ln3m3ZyK8Q3BHL+lHXkHW30sVN
	7Z/qfoXeNpX5N1H2746WrvuVf+p2qXc41mz6vfBQUfOS7VWPfBcZ8Mx68f76I8NI80Mtv/ba
	WV87//zAg96gU/+y98jNn/L85R/5Ca+mu4Ype+5h7/nu4JN9YcKukDjBeDMTJZbijERDLeai
	4kQA91pgMcYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t9jQd3Nsv4hBjPfaFp8vHaB3WLC5e2M
	Fi8PaVpcmLaQ2WLf+ymMFp+vN7Fb3PjVxmpxedccNosj//sZLT7cv8hscXxtuAO3R9fbK0we
	d67tYfO48Wohk0ffllWMHp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxhzHj/u5G9YIdwRfvmXYwNjGv4uxg5OCQETCSOzRXsYuQEMsUkLtxbzwZiCwlMZ5T4vjW/
	i5ELyH7NKLHs+kZWkHpeAS2Jjns+IDUsAqoSR1fuZQax2QR0JLZ/O84EYosKhEkcapsHZvMK
	CEr8mHyPBWSOiMAuRokLCz+CJZgF1jJKLF6gBWILC1hK9N/cwg6x2FHi2ISVYEM5BZwk5h09
	BlWvI7G/dRobhC0vsXnNW+YJjAKzkOyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGC4/6Z1A7GlQ0WhxgFOBiVeHgNHvqFCLEmlhVX5h5ilOBgVhLh9doBFOJNSaysSi3K
	jy8qzUktPsRoCgyCicxSosn5wJSUVxJvaGxiZmRpZG5oYWRsriTOe6DVOlBIID2xJDU7NbUg
	tQimj4mDU6qBMbjopaogQ0/mKfOLSvqtr5yuT3sdF9qosYPzUsedmx6TU5dsjS5RqOTiDD0i
	eyB4Sk634daGl+JrrWP6dj3RFG13fClR7vSn5tCShTu5Xh+5bbSl+PqS0mfxX5hUTm5qrtD7
	oH3r1bWO6nkPJ3XxyQdP5FiduN7Al+FL9kWhNaY+V4s6Z+wSV2Ipzkg01GIuKk4EAFxUWv8R	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Chanho.

On 10/22/2014 11:55 AM, Chanho Min wrote:
> According to JEDEC v5.01 spec (6.6.5), In order to switch to HS400 mode,
> host should perform the following steps.
> 
>  1. HS200 mode selection completed
>  2. Set HS_TIMING to 0x01(High Speed)
>  3. Host changes frequency to =< 52MHz
>  4. Set the bus width to DDR 8bit (CMD6)
>  5. Host may read Driver Strength (CMD8)
>  6. Set HS_TIMING to 0x03 (HS400)
> 
> In current implementation, the order of 2 and 3 is reversed.
> The HS_TIMING field should be set to 0x1 before the clock frequency
> is set to a value not greater than 52 MHz. Otherwise, Initialization of
> timing can be failed. Also, the host contoller's UHS timing mode should
> be set to DDR50 after the bus width is set to DDR 8bit.
> 
> Signed-off-by: Hankyung Yu <hankyung.yu@lge.com>
> Signed-off-by: Chanho Min <chanho.min@lge.com>
> ---
>  drivers/mmc/core/mmc.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index a301a78..52f78e0 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -1061,9 +1061,6 @@ static int mmc_select_hs400(struct mmc_card *card)
>  	 * Before switching to dual data rate operation for HS400,
>  	 * it is required to convert from HS200 mode to HS mode.
>  	 */
> -	mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
> -	mmc_set_bus_speed(card);
> -
>  	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>  			   EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS,
>  			   card->ext_csd.generic_cmd6_time,
> @@ -1074,6 +1071,14 @@ static int mmc_select_hs400(struct mmc_card *card)
>  		return err;
>  	}
>  
> +	/*
> +	 * According to JEDEC v5.01 spec (6.6.5), Clock frequency should
> +	 * be set to a value not greater than 52MHz after the HS_TIMING
> +	 * field is set to 0x1.
> +	 */
> +	mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
> +	mmc_set_bus_speed(card);
> +
>  	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>  			 EXT_CSD_BUS_WIDTH,
>  			 EXT_CSD_DDR_BUS_WIDTH_8,
> @@ -1084,6 +1089,8 @@ static int mmc_select_hs400(struct mmc_card *card)
>  		return err;
>  	}
>  
> +	mmc_set_timing(card->host, MMC_TIMING_MMC_DDR52);
> +

I didn't know why timing is set to ddr50.

Best Regards,
Jaehoon Chung

>  	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>  			   EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS400,
>  			   card->ext_csd.generic_cmd6_time,
> 

