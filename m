Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaDOAdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:33:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30898 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaDOAdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:33:05 -0400
X-AuditID: cbfee690-b7f266d00000287c-70-534c7e409160
From: Jingoo Han <jg1.han@samsung.com>
To: "'Christian Engelmayer'" <cengelma@gmx.at>,
        "'Brian Norris'" <computersforpeace@gmail.com>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, "'Pekon Gupta'" <pekon@ti.com>,
        "'Artem Bityutskiy'" <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20140415003205.0bb2cf44@spike>
In-reply-to: <20140415003205.0bb2cf44@spike>
Subject: =?utf-8?Q?Re:_=5BPATCH=5D_mtd:_nand:_omap:_fix?=
	=?utf-8?Q?_compile_warning_on_=E2=80=98erased=5Fsect?=
	=?utf-8?Q?or=5Fbitflips=E2=80=99?=
Date: Tue, 15 Apr 2014 09:33:03 +0900
Message-id: <007d01cf5842$435dcba0$ca1962e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9YMWblLG2q3V2ESE+KWJVfGHIuJAAELwlw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zY12HOp9ggwVLmC3ePH7GbPHhwhxG
	iyMX1jJbTFw5mdni8sJLrBaXd81hs9jdtIzdYnbDLjYHDo+ds+6ye/xfMYHdY/MKLY95JwM9
	Ni+p9+jbsorR4/iN7UwenzfJBXBEcdmkpOZklqUW6dslcGXMuLebsaCbu+L9r0VsDYz9nF2M
	nBwSAiYSB6+vYIOwxSQu3FsPZHNxCAksY5RYdvEpYxcjB1jRiSl+IDVCAosYJT73pULU/GaU
	mL30JDtIgk1ATeLLl8PsIPUiAjESX5ZxgdQwCzxnlGi5/4EJollbYvO+NhYQm1NAR+LO1u/M
	IEXCAtMZJV4cmcUK0swioCpxtFcLpIZXwFZifdt2dghbUOLH5HssICXMAuoSU6bkgoSZgUY+
	eXeBFeJMdYlHf3UhLjCSONLnCFEhIrHvxTtGiA87OSSOLRQDsVkEBCS+TT7EAtEpK7HpADNE
	iaTEwRU3WCYwSsxCsnYWwtpZSNbOQrJgASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQ
	qJ6wg/HeAetDjMlA2ycyS4km5wOTQl5JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MOYmXMhZVzHzp3GT4Lts/bBL4m1fCxhMIp/sK+AyaDj4VuDF
	8X2+Zl/76n4laeRuPxGTOfXniQXPCzbu6w01NZWVnxirt/fopw6D/YU6f5d9P77v0IKqFwJL
	+ANNf4VdvLHK7NOyaZzz1NUO3pJY1Sug2/Tp9gsuoTKVpqmhkycc/smQ/j5LN1qJpTgj0VCL
	uag4EQCfoYJ6AAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAV37Op9gg86j1hZvHj9jtvhwYQ6j
	xZELa5ktJq6czGxxeeElVovLu+awWexuWsZuMbthF5sDh8fOWXfZPf6vmMDusXmFlse8k4Ee
	m5fUe/RtWcXocfzGdiaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jFmzLi3m7Ggm7vi/a9FbA2M/ZxdjBwcEgImEiem+HUxcgKZYhIX7q1nA7GFBBYxSnzuS+1i
	5AKyfzNKzF56kh0kwSagJvHly2F2kF4RgRiJL8u4QGqYBZ4zSrTc/8AE0awtsXlfGwuIzSmg
	I3Fn63dmkCJhgemMEi+OzGIFaWYRUJU42qsFUsMrYCuxvm07O4QtKPFj8j0WkBJmAXWJKVNy
	QcLMQCOfvLvACnGyusSjv7oQFxhJHOlzhKgQkdj34h3jBEahWUjmzEKYMwvJnFlIOhYwsqxi
	FE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4az6R2MK5ssDjEKMDBqMTDO+Gdd7AQa2JZcWXu
	IUYJDmYlEd7XyT7BQrwpiZVVqUX58UWlOanFhxiTgZ6cyCwlmpwPTGh5JfGGxiZmRpZGZhZG
	JubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cDI9X7H7mV7uHsdgoo9zd7+0t93SjVg
	3uFzSvbpTK0hyYxf5j3Tqus8sEw9I8zoasDsz1+OPmHvO/TW427r0xUN1ScL0nU/5/iHs55W
	51soI73zz7wlfz/93uk3f/l6ySc1R7ROi5+Pf9byoS7087rF+a3JMt+0Dd7rFwSes5J+L5Gw
	ZsfpP5URSizFGYmGWsxFxYkAQG1FrF4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 15, 2014 7:32 AM, Christian Engelmayer wrote:
> 
> Commit 2c9f2365 (mtd: nand: omap: ecc.calculate: merge omap3_calculate_ecc_bch4
> in omap_calculate_ecc_bch) introduced minor compile warning
> "‘erased_sector_bitflips’ defined but not used [-Wunused-function]" when
> compiling without CONFIG_MTD_NAND_OMAP_BCH. Move function
> erased_sector_bitflips() into the same ifdef section as the only caller.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/mtd/nand/omap2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> index 1ff49b8..1b800bc 100644
> --- a/drivers/mtd/nand/omap2.c
> +++ b/drivers/mtd/nand/omap2.c
> @@ -1237,6 +1237,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
>  	return 0;
>  }
> 
> +#ifdef CONFIG_MTD_NAND_OMAP_BCH
>  /**
>   * erased_sector_bitflips - count bit flips
>   * @data:	data sector buffer
> @@ -1276,7 +1277,6 @@ static int erased_sector_bitflips(u_char *data, u_char *oob,
>  	return flip_bits;
>  }
> 
> -#ifdef CONFIG_MTD_NAND_OMAP_BCH
>  /**
>   * omap_elm_correct_data - corrects page data area in case error reported
>   * @mtd:	MTD device structure
> --
> 1.8.3.2

