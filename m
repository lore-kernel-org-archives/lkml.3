Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaJ1TKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:10:24 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43396 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaJ1TKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:10:23 -0400
Message-ID: <544FEA1B.2050006@cogentembedded.com>
Date: Tue, 28 Oct 2014 22:10:19 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: at91: fix compilation
References: <1414522686-5755-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1414522686-5755-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/28/2014 09:58 PM, Alexandre Belloni wrote:

> Add macros introduced by 4334ac2db2be9e278c95fd15260c1f49f698ffc5 that

    Please also specify that commit's summary line in parens.

> were missed when copying the header.

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   drivers/pinctrl/pinctrl-at91.h | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/pinctrl/pinctrl-at91.h b/drivers/pinctrl/pinctrl-at91.h
> index c837c66ea360..79b957f1dfa2 100644
> --- a/drivers/pinctrl/pinctrl-at91.h
> +++ b/drivers/pinctrl/pinctrl-at91.h
> @@ -63,4 +63,10 @@
>   #define PIO_FRLHSR	0xd8	/* Fall/Rise - Low/High Status Register */
>   #define PIO_SCHMITT	0x100	/* Schmitt Trigger Register */
>
> +#define SAMA5D3_PIO_DRIVER1		0x118  /*PIO Driver 1 register offset*/
> +#define SAMA5D3_PIO_DRIVER2		0x11C  /*PIO Driver 2 register offset*/
> +
> +#define AT91SAM9X5_PIO_DRIVER1	0x114  /*PIO Driver 1 register offset*/
> +#define AT91SAM9X5_PIO_DRIVER2	0x118  /*PIO Driver 2 register offset*/

    Please add spaces after /* and before */.

WBR, Sergei

