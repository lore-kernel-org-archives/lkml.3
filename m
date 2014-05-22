Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaEVAyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:54:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28031 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaEVAyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:54:52 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-f9-537d4ad983ae
From: Jingoo Han <jg1.han@samsung.com>
To: "'Roger Quadros'" <rogerq@ti.com>
Cc: tony@atomide.com, computersforpeace@gmail.com, pekon@ti.com,
        ezequiel.garcia@free-electrons.com, robertcnelson@gmail.com,
        dwmw2@infradead.org, javier@dowhile0.org, nsekhar@ti.com,
        linux-omap@vger.kernel.org, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Christian Engelmayer'" <cengelma@gmx.at>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
 <1400671264-10702-9-git-send-email-rogerq@ti.com>
In-reply-to: <1400671264-10702-9-git-send-email-rogerq@ti.com>
Subject: Re: [RFC PATCH 08/16] mtd: nand: omap: Fix build warning
Date: Thu, 22 May 2014 09:54:59 +0900
Message-id: <02cd01cf7558$7500eb00$5f02c100$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9051RxCLyonJ47TQK529i7wl6PfgAbrt3Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t8zY92bXrXBBl/b9Cw+XJjDaHHkwlpm
	i/lHzrFaTFw5mdni9KkFrBbXfs9gs7i88BKrxeVdc9gsdjctY7eYvaSfxWJ/7wYmi9kNu9gs
	3i/5yGjR80jLYv8VLwd+j29fJ7F4/J3dyuzxZNNFRo+ds+6ye/xfMYHdY/MKLY/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGbfXPmQquMRdsefrIdYGxjOcXYycHBICJhIn
	5h9ng7DFJC7cWw9kc3EICSxjlFjy8QwLTNHeO81MEIlFjBKXHjSzQzi/GSUavxxgB6liE1CT
	+PLlMJgtIqAsMe3HD7BRzALNzBIXH/wFGyUkUChx7NRxJhCbU8BOYs66LlYQW1jAUWLnwb9g
	NouAqsSh1k3MIDavgK3E/QkfmCBsQYkfk+8BzeEAGqouMWVKLkiYWUBb4sm7C6wgYQmg8KO/
	uhAnGEk0PFjMAlEiIrHvxTtGkHMkBE5wSEzZsI0RYpWAxLfJh1ggemUlNh1ghnhYUuLgihss
	ExglZiFZPAth8Swki2ch2bCAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkja6N3BePuA
	9SHGZKDtE5mlRJPzgWknryTe0NjMyMLUxNTYyNzSjDRhJXHepIdJQUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoYBR2Cz3wTX3stdWa8uPmk10t/9kR5PTg5U/gpQ0rRDptn6z5e1LacfSHA
	ryiNaY3j/kgb9U+KB9g+Wq7Iebb90oNXoZXSOZvr7ycF7v0VV/8pMCRq/4qkyHcrjl6MKb3i
	Nf2ir+sStUei0WEnNokwJLdf8fobFBMX2PH85dWY9fd4PtZxM9yfqMRSnJFoqMVcVJwIAFLB
	bLIxAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jAd2bXrXBBs+Palh8uDCH0eLIhbXM
	FvOPnGO1mLhyMrPF6VMLWC2u/Z7BZnF54SVWi8u75rBZ7G5axm4xe0k/i8X+3g1MFrMbdrFZ
	vF/ykdGi55GWxf4rXg78Ht++TmLx+Du7ldnjyaaLjB47Z91l9/i/YgK7x+YVWh6bl9R79G1Z
	xehx/MZ2Jo/Pm+QCuKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNT
	bZVcfAJ03TJzgJ5QUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWbcXvuQ
	qeASd8Wer4dYGxjPcHYxcnJICJhI7L3TzARhi0lcuLeerYuRi0NIYBGjxKUHzewQzm9GicYv
	B9hBqtgE1CS+fDkMZosIKEtM+/EDrINZoJlZ4uKDvywgCSGBQoljp46DjeUUsJOYs66LFcQW
	FnCU2HnwL5jNIqAqcah1EzOIzStgK3F/wgcmCFtQ4sfke0BzOICGqktMmZILEmYW0JZ48u4C
	K0hYAij86K8uxAlGEg0PFrNAlIhI7HvxjnECo9AsJINmIQyahWTQLCQdCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEJ6Vn0jsYVzVYHGIU4GBU4uG9cb4mWIg1say4MvcQowQHs5II
	b4dybbAQb0piZVVqUX58UWlOavEhxmSgNycyS4km5wMTZl5JvKGxiZmRpZGZhZGJuTlpwkri
	vAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MPrcrm7c76Zw1nTmLj4768/PPD/UuaRtVL9W+fea
	/5593/a1bmK1XSe5YLHHkoeZS5TP6H80f+EsvzNC1c2P3UMkP8XN96gdB8taN42TW19tVxOY
	ULmB2aprmWv+hS1vrMSvrXmZwvAhy8bJfjfvtYeMnmaLmPI9ewzX3PxrrBzR7LBZJpNLW4ml
	OCPRUIu5qDgRAJqUxOCOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 21, 2014 8:21 PM, Roger Quadros wrote:
> 
> Fix the following warning when CONFIG_MTD_NAND_OMAP_BCH is disabled.
> warning: ‘erased_sector_bitflips’ defined but not used [-Wunused-function]
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>

(+cc Christian Engelmayer)

The same patch was already sent by Christian Engelmayer. [1]
Also, it was applied to mtd tree by Brian Norris. [2]
Thank you.

[1] http://lists.infradead.org/pipermail/linux-mtd/2014-April/053330.html
[2] http://git.infradead.org/users/dedekind/l2-mtd.git/commit/9fd6c6c18c1a4a3220473c76fd447c5708b5ecf9

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

