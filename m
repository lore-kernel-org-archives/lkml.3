Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaIKCii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 22:38:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54742 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaIKCig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 22:38:36 -0400
X-AuditID: cbfee68e-f79536d000000fd1-6b-54110b293a0d
Message-id: <54110B29.7030303@samsung.com>
Date: Thu, 11 Sep 2014 11:38:33 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: tgih.jun@samsung.com, ulf.hansson@linaro.org, chris@printf.net
Subject: Re: [PATCH] mmc: Add delay between CMD6 and CMD13 for Sandisk eMMC
 cards
References: <1410265614-3275-1-git-send-email-jean-michel.hautbois@vodalys.com>
In-reply-to: <1410265614-3275-1-git-send-email-jean-michel.hautbois@vodalys.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWyRsSkWFeLWzDE4EidxYTL2xktjj3ZyWpx
	edccNosj//sZLT7cv8hscXxtuAObx51re9g8brxayOTRt2UVo8fnTXIe20/MZQpgjeKySUnN
	ySxLLdK3S+DKuHXvN3PBPe6K01OWsTYwLuTsYuTkkBAwkZjYvJIFwhaTuHBvPVsXIxeHkMBS
	RolfbzewwxTdbVnLBJGYzihxb8dCFgjnNaNEV/seZpAqXgEtiXW/GsFsFgFViY3rFoLZbAI6
	Etu/HWcCsUUFwiQOtc1jgqgXlPgx+R7QIA4OEYEyiWmba0HCzAJOEuvWHQALCwsES5ydYQkS
	FhLwl1j2cg1YJ6dAgMScRQ1MEOU6Evtbp7FB2PISm9e8ZQY5TULgELvE5E2rGCHOEZD4NvkQ
	2EwJAVmJTQeYIf6SlDi44gbLBEaxWUgOmoVk7CwkYxcwMq9iFE0tSC4oTkovMtIrTswtLs1L
	10vOz93ECIyz0/+e9e1gvHnA+hCjAAejEg9vBYtgiBBrYllxZe4hRlOgKyYyS4km5wOjOa8k
	3tDYzMjC1MTU2Mjc0kxJnDdB6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsa5bbcWK05P
	T17IdvFZVPyc7cHMB+ef/JvtVGW/ccmkiJAX2z/MOhrN/f7d0p47J37YR7HN6LmpzqR22vMx
	t2TslnzuaSI/OVb4rz8iVtGhxtw3I8vqbEnhxjfbZ8pFOe9ze/N6Yf6bgPvfGhZOkvjZFRqz
	/d99VvZpMZt/nlo8bd+zx+fYf8x6rsRSnJFoqMVcVJwIAFOpp4CuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQV1NbsEQg+2nzCwmXN7OaHHsyU5W
	i8u75rBZHPnfz2jx4f5FZovja8Md2DzuXNvD5nHj1UImj74tqxg9Pm+S89h+Yi5TAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMW/d+Mxfc4644PWUZawPjQs4uRk4O
	CQETibsta5kgbDGJC/fWs3UxcnEICUxnlLi3YyELhPOaUaKrfQ8zSBWvgJbEul+NYDaLgKrE
	xnULwWw2AR2J7d+Og00SFQiTONQ2jwmiXlDix+R7QIM4OEQEyiSmba4FCTMLOEmsW3cALCws
	ECxxdoYlSFhIwF9i2cs1YJ2cAgEScxY1MEGU60jsb53GBmHLS2xe85Z5AqPALCQLZiEpm4Wk
	bAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Dh+JrWDcWWDxSFGAQ5GJR7eChbBECHW
	xLLiytxDjBIczEoivAkPBEKEeFMSK6tSi/Lji0pzUosPMZoC/T+RWUo0OR+YYvJK4g2NTcyM
	LI3MDS2MjM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTB6y9yOKIve1dUotTCzs6ZO//Zc
	3g98pzQD5u1ifLbzfd2iKK0f9nEmBzTyNq5OYrD6veLilzi2y7lx5ULcZa8fmE6t3Woza/qj
	nUvum/TkF/B5zel7lOuXr6GYHHQ6Ys41t7rwPKeThwN4rs35wDWT8fPD3zs/3Jjcvfj1727v
	4MuRW4/Ecq9UYinOSDTUYi4qTgQAWo/IQPkCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/09/2014 09:26 PM, Jean-Michel Hautbois wrote:
> Tested on a i.MX6 board, with Sandisk SDIN5D1-2G.
> Without this patch, I/O errors occur.
> This eMMC seems to have a different Manufacturer ID as it reads 0x45
> and not 0x2 as specified in datasheet.

I think this patch don't merge into mainline.
This is not solution for problem.
you mentioned the below comment, this is workaround.

> 
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> ---
>  drivers/mmc/core/mmc_ops.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index f51b5ba..91babaa 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -458,6 +458,15 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
>  	if (!use_busy_signal)
>  		return 0;
>  
> +	/* WORKAROUND: for Sandisk eMMC cards, it might need certain delay
> +	 * before sending CMD13 after CMD6
> +	 * On SDIN5D1-2G MANFID is 0x45 and not 0x2 as specified in datasheet
> +	 */
> +	if (card->cid.manfid == CID_MANFID_SANDISK ||
> +		card->cid.manfid == 0x45) {
> +		msleep(1);
> +	}

If it's a general problem of Sandisk SDIN5D1-2G,
I think you need to verify this problem. And can you use the MMC_FIXUP() and QUIRK?

Best Regards,
Jaehoon Chung

> +
>  	/*
>  	 * CRC errors shall only be ignored in cases were CMD13 is used to poll
>  	 * to detect busy completion.
> 

