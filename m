Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaIACrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:47:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12447 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaIACrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:47:51 -0400
X-AuditID: cbfee691-f79546d0000011a1-ae-5403de553e16
From: Jingoo Han <jg1.han@samsung.com>
To: "'bpqw'" <bpqw@micron.com>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Brian Norris'" <computersforpeace@gmail.com>,
        "'Christian Riesch'" <christian.riesch@omicron.at>,
        "'Paul Gortmaker'" <paul.gortmaker@windriver.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <A765B125120D1346A63912DDE6D8B6315DB7BE@NTXXIAMBX02.xacn.micron.com>
In-reply-to: <A765B125120D1346A63912DDE6D8B6315DB7BE@NTXXIAMBX02.xacn.micron.com>
Subject: Re: [PATCH 1/1] mtd: cfi_cmdset_0002:add fixup for Micron M29EW after
 erase operation
Date: Mon, 01 Sep 2014 11:47:43 +0900
Message-id: <013d01cfc58f$1e4c0f10$5ae42d30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/FirFoX5r9fafZSu+Pmx6RITsSBwAAIQmwAADXYRA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zY93Qe8whBvvWmFhsm7+d0eJ680Z2
	iyMX1jJbTFw5mdni8sJLrBaXd81hs9jdtIzd4tre48wOHB47Z91l99i8Qstj85J6j+/rO9g8
	Vk9YxubRt2UVo8fnTXIe67dsZQrgiOKySUnNySxLLdK3S+DK2D/lMlPBA+6K7jnaDYyHObsY
	OTkkBEwkZp/vYoGwxSQu3FvP1sXIxSEksIxRou3tdFaYohv9r1kgEtMZJfpeHYFyfjNKtO9f
	xQxSxSagJvHly2F2EFtEQEbi2+V1YKOYBZYzSax6fA6sSEggQGL2uQOMIDanQLDE4d9/wHYL
	CyRItJ57DGazCKhK7Ny+CMzmFbCVWHHiFSOELSjxY/I9sDizgJbE+p3HmSBseYnNa94CzecA
	OlVd4tFfXYgbrCQ6175mhigRkdj34h0jyD0SAo0cEquedLND7BKQ+Db5EAtEr6zEpgPMEB9L
	ShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJERLj
	E3cw3j9gfYhRgINRiYf3wSzmECHWxLLiytxDjKZAF01klhJNzgcmkrySeENjMyMLUxNTYyNz
	SzMlcV4d6Z/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiF+V9LpDK8PGi7OV6Rt/FBsut0
	oWLGrG/V7b4uc0/pZd+w/WP84RrDb1XJBtVvVkcaHr+vNgz4+lxDn9tYMfg6x3lNTYv/vuWL
	+NYu1n/ff2pCqqzd145JLCF/b7a0L7nh7avttHRlprbvvunPV2zZuN2+aPnLW7VTxRuXnftp
	ke7Dzm677ZYSS3FGoqEWc1FxIgCeg58X7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jQd3Qe8whBjd6DCy2zd/OaHG9eSO7
	xZELa5ktJq6czGxxeeElVovLu+awWexuWsZucW3vcWYHDo+ds+6ye2xeoeWxeUm9x/f1HWwe
	qycsY/Po27KK0ePzJjmP9Vu2MgVwRDUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzNg/5TJTwQPuiu452g2Mhzm7GDk5JARMJG70v2aBsMUkLtxbz9bFyMUhJDCdUaLv1REW
	COc3o0T7/lXMIFVsAmoSX74cZgexRQRkJL5dXgfWwSywnEli1eNzYEVCAgESs88dYASxOQWC
	JQ7//gO2QlggQaL13GMwm0VAVWLn9kVgNq+ArcSKE68YIWxBiR+T74HFmQW0JNbvPM4EYctL
	bF7zFmg+B9Cp6hKP/upC3GAl0bn2NTNEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgBPJMegfjqgaLQ4wCHIxKPLwPZjGHCLEmlhVX5h5i
	lOBgVhLhPXIaKMSbklhZlVqUH19UmpNafIjRFOjRicxSosn5wOSWVxJvaGxiZmRpZGZhZGJu
	riTOe7DVOlBIID2xJDU7NbUgtQimj4mDU6qBMephpKvHfRlhOR7jnGUxv3hPfJuq9Udm0VSb
	IF+elIq5U7m+v7NYbC4svfuW4I6cRZs9pbl8r1S2hF+Rim9Ik9Da5C5cVH+6x1t57pOmbZJG
	Kc4ucg2z91eKsO5r0+9XOuA135DT4PD9Bwn7u9bMbPjuNTexy2qz2vF3267wrf14IaPrTfsW
	JZbijERDLeai4kQAU/WnXzYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 01, 2014 11:21 AM, Bean Huo wrote:
> 
> For Micron M29EW,20ms delay is needed after erase operation.

You already added the reason to cfi_fixup_m29ew_delay_after_erase().
However, please add the comment to this commit message.

> 
> Signed-off-by: BeanHuo <bpqw@micron.com>

BeanHuo/Bean Huo

Others look good.

Best regards,
Jingoo Han

> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> index 5a4bfe3..9b0de91 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -509,6 +509,16 @@ static void cfi_fixup_m29ew_delay_after_resume(struct cfi_private *cfi)
>  		cfi_udelay(500);
>  }
> 
> +static void cfi_fixup_m29ew_delay_after_erase(struct cfi_private *cfi)
> +{
> +	/*
> +	 * Resolving the Delay After ERASE Issue @low temperature.
> +	 * 20ms delay is needed after erase operation.
> +	 */
> +	if (is_m29ew(cfi))
> +		cfi_udelay(20000);
> +}
> +
>  struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)  {
>  	struct cfi_private *cfi = map->fldrv_priv; @@ -2397,6 +2407,7 @@ static int __xipram
> do_erase_oneblock(struct map_info *map, struct flchip *chip,
>  		ret = -EIO;
>  	}
> 
> +	cfi_fixup_m29ew_delay_after_erase(cfi);
>  	chip->state = FL_READY;
>  	DISABLE_VPP(map);
>  	put_chip(map, chip, adr);
> --
> 1.7.9.5

