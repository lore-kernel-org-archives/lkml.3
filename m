Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab3GBDFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:05:20 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:30754 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3GBDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:05:18 -0400
Message-ID: <51D24366.5000101@atmel.com>
Date: Tue, 2 Jul 2013 11:05:10 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [RFC PATCH 03/13] ARM: at91: DTS: sam9x5: add clock for SSC DT
 entry
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com> <1372667978-4718-4-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1372667978-4718-4-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 7/1/2013 16:39, Richard Genoud wrote:
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>   arch/arm/mach-at91/at91sam9x5.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
> index 2abee66..191eb4b 100644
> --- a/arch/arm/mach-at91/at91sam9x5.c
> +++ b/arch/arm/mach-at91/at91sam9x5.c
> @@ -233,6 +233,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
>   	CLKDEV_CON_DEV_ID("mci_clk", "f000c000.mmc", &mmc1_clk),
>   	CLKDEV_CON_DEV_ID("dma_clk", "ffffec00.dma-controller", &dma0_clk),
>   	CLKDEV_CON_DEV_ID("dma_clk", "ffffee00.dma-controller", &dma1_clk),
> +	CLKDEV_CON_DEV_ID("pclk", "at91sam9g45_ssc.0", &ssc_clk),

Actually, we don't use this anymore. Am I right?

>   	CLKDEV_CON_DEV_ID("pclk", "f0010000.ssc", &ssc_clk),
>   	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
>   	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
>

Best Regards,
Bo Shen
