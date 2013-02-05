Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab3BEFco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:32:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61423 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3BEFcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:32:42 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-00-511099770109
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Olof Johansson'" <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1358959242-1667-1-git-send-email-tobetter@gmail.com>
 <1360025780-17158-1-git-send-email-tobetter@gmail.com>
In-reply-to: <1360025780-17158-1-git-send-email-tobetter@gmail.com>
Subject: RE: [PATCH] ARM: dts: Fix the timing property of MSHC controller
Date: Mon, 04 Feb 2013 21:32:27 -0800
Message-id: <124f01ce0362$30b5eb30$9221c190$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJukooklfXeOqMGu0MAxZ6x5EO6awEX0c7klyDf9wA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zA93ymQKBBp8uaVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mxu09bAVH2Csuv/zO1sDYyNbFyMkhIWAicav5ISOELSZx4d56
	oDgXh5DAMkaJKVP2MMIUfZ1xkxEiMZ1RYvLS1VDOPCaJndfesIBUsQloSBx+/4wdxBYRUJNo
	/NvJClLELDCFUWL12y9MIAkhgSqJtosHwIo4BZwl/lx5CRYXFvCUeDHjKJjNIqAqcWzaUVYQ
	m1fAUmLXrR3sELagxI/J98CWMQtoSazfeZwJwpaX2LzmLTPEqQoSO86+ZoQ4wkri96RDzBA1
	4hKTHjxkBzlIQmARu8Tl5hPsEMsEJL5NPgQ0lAMoISux6QDUHEmJgytusExglJiFZPUsJKtn
	IVk9C8mKBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzFC4ktqB+PKBotDjAIcjEo8vD8u
	8wcKsSaWFVfmHmKU4GBWEuH9eAMoxJuSWFmVWpQfX1Sak1p8iDEZ6NiJzFKiyfnA2M8riTc0
	NjYxMzE1Mbc0NTclTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxSDYxOe+3M21omacw4XS/M
	tv6Jb9biAFHPm/Pe3XkRb/XVPuPbRf4/3zZvidV6X82asXP2jkXiH78U7lUuupEnxvJOr+iO
	oXKZ5bbF8UeT2G/1KYpZrJd+oa4e0B3+ICcyb6baikz/xrQDAo7SLMZC5+QKty3POnFl5Zxd
	TtL37Y8881FcXjrt3kklluKMREMt5qLiRAC6sVFs8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoG75TIFAgynz1Swu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRuP2HraCI+wVl19+Z2tg
	bGTrYuTkkBAwkfg64yYjhC0mceHeeqA4F4eQwHRGiclLVzNCOPOYJHZee8MCUsUmoCFx+P0z
	dhBbREBNovFvJytIEbPAFEaJ1W+/MIEkhASqJNouHgAr4hRwlvhz5SVYXFjAU+LFjKNgNouA
	qsSxaUdZQWxeAUuJXbd2sEPYghI/Jt8DW8YsoCWxfudxJghbXmLzmrfMEKcqSOw4+5oR4ggr
	id+TDjFD1IhLTHrwkH0Co9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvX
	S87P3cQIjt5nUjsYVzZYHGIU4GBU4uH9cZk/UIg1say4MvcQowQHs5II78cbQCHelMTKqtSi
	/Pii0pzU4kOMyUCfTmSWEk3OByaWvJJ4Q2MTMyNLIzMLIxNzc9KElcR5GU89CRASSE8sSc1O
	TS1ILYLZwsTBKdXAKHklNNp1S6WqrbNnQJnJwjnHd3uFOc+Jc+TqfXPl/B6uG3k3+HcHLg55
	o+DG1KdwxEB18lvnuZyzpS1/nH53dVJ31orZJVmy2xcrNLn+WvlZYc2dj7XJ0+/cd7abWbTx
	/dtbgT8sd16Z4HXQ89f+4EDulZ+Wm+2PVK/+kSq81Wm1SdS8i84TU5VYijMSDbWYi4oTAR2E
	8ioiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongjin Kim wrote:
> 
> This fixes the property of dw-mshc-sdr-timing and dw-mshc-ddr-timing as
> per
> its current binding, it only has two cells.
> 
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/exynos4412-odroidx.dts |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts
> b/arch/arm/boot/dts/exynos4412-odroidx.dts
> index f41a84e..009a9c2 100644
> --- a/arch/arm/boot/dts/exynos4412-odroidx.dts
> +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
> @@ -49,8 +49,8 @@
>  		fifo-depth = <0x80>;
>  		card-detect-delay = <200>;
>  		samsung,dw-mshc-ciu-div = <3>;
> -		samsung,dw-mshc-sdr-timing = <2 3 3>;
> -		samsung,dw-mshc-ddr-timing = <1 2 3>;
> +		samsung,dw-mshc-sdr-timing = <2 3>;
> +		samsung,dw-mshc-ddr-timing = <1 2>;
> 
>  		slot@0 {
>  			reg = <0>;
> --
> 1.7.10.4

Looks good to me, applied.

Thanks.

- Kukjin

