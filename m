Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaD1BmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:42:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39418 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaD1Bl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:41:58 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-c2-535db1e3184f
Date: Mon, 28 Apr 2014 01:41:55 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] PM / devfreq: Use freq_table for available_frequencies
To: Saravana Kannan <skannan@codeaurora.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140428013700674@myungjoo.ham
Msgkey: 20140428013700674@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140428013700674@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <4324793.197151398649314597.JavaMail.weblogic@epv6ml10>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSovt4Y2ywwbajxhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj4owljAUtMhV7pqxmbWBcIt3FyMkhJKAusWjJSTYQW0LARGJ2
	Zy8zhC0mceHeeqA4F1DNUkaJxxPesMAUfb73CSoxh1Fi0pRPYN0sAqoSmz7uB+rm4GAT0JOY
	+TkZJCws4Ccx++91VhBbRCBfonfnTSaQXmaBPiaJlfMfsUFcoSSxZt8rsAW8AoISJ2c+gVqm
	KnH98AFWiLiaxM1fM6Cuk5CYNf0CK4TNKzGj/SlUvZzEtK9roGqkJc7P2sAI883i74+h4vwS
	x27vYAK5E6T3yf1gmDG7N3+BBoSAxNQzB6FatSQaO59CtfJJrFn4lgVmzK5Ty5lheu9vmcsE
	YjMLKEpM6X7IDmFrSXz5sY8N3Vu8As4S+9f0s09gVJ6FJDULSfssJO3IahYwsqxiFE0tSC4o
	TkovMtErTswtLs1L10vOz93ECEwMp/89m7CD8d4B60OMycAomcgsJZqcD0wseSXxhsZmRham
	JqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA2H5Y+/qr638fvZiw
	wF3f6MqXSRJvVf5HB892MbqSObtbJvh++pofqwNZ26RTvtUxWv7ZGWooUF86JzngBUt2j9B2
	vStBTmfuqty6JL1nVmlT7KJbPSlitV0/Fq3b2n3w6d+FTmnzX5zKKzDTaJB0XfxZLuvMp2N2
	/F6xpo/UtGX8WVbMiAu9rcRSnJFoqMVcVJwIAIuNXkIiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e92v+7jjbHBBk9e6Vhc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIyL
	M5YwFrTIVOyZspq1gXGJdBcjJ4eQgLrEoiUn2UBsCQETic/3PkHZYhIX7q0HsrmAauYwSkya
	ApFgEVCV2PRxP3MXIwcHm4CexMzPySBhYQE/idl/r7OC2CIC+RK9O28ygfQyC/QxSayc/4gN
	YpmSxJp9r1hAbF4BQYmTM5+wQCxTlbh++AArRFxN4uavGcwQcQmJWdMvsELYvBIz2p9C1ctJ
	TPu6BqpGWuL8rA2MMEcv/v4YKs4vcez2DiaQO0F6n9wPhhmze/MXqB8FJKaeOQjVqiXR2PkU
	qpVPYs3CtywwY3adWs4M03t/y1wmEJtZQFFiSvdDdghbS+LLj31s6N7iFXCW2L+mn30Co9ws
	JKlZSNpnIWlHVrOAkWUVo2hqQXJBcVJ6haFecWJucWleul5yfu4mRnB6erZwB+OX89aHGAU4
	GJV4eCPmxAYLsSaWFVfmHmKU4GBWEuFdPhcoxJuSWFmVWpQfX1Sak1p8iDEZGIETmaVEk/OB
	qTOvJN7Q2NjEzMTU0sTCwNScNGElcd67N5OChATSE0tSs1NTC1KLYLYwcXBKNTAmzG/2lJ+5
	5GPSnn85h21FPkiF7082m3J3+0KbKsk/yxM0jb0bdfatzjh0veaQVdjj/wcKLt+xY+XzZDoc
	fcZVxnjrM5GMl6Grtp+8zSPZYvPr9GlOxt7slKPuaqrO1pfm7r00x+b5xe0s6za8F9/kF7Q3
	Mlfy0KE7r4yTi4Sy9xvGZyZzrpJRYinOSDTUYi4qTgQACP6KXpMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3S1gFFO019121

> Some devices use freq_table instead of OPP. For those devices, the
> available_frequencies file shows up empty. Fix that by using freq_table to
> generate the available_frequencies data when it's available.
> 
> OPP find frequency APIs also skips frequencies that have been temporarily
> disabled (say, due to thermal, etc). Since available_frequencies is
> supposed to show the entire list of available frequencies without taking
> temporary limits into consideration, preference is given to freq_table when
> available.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  drivers/devfreq/devfreq.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 2042ec3..527cbe2 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -912,20 +912,27 @@ static ssize_t available_frequencies_show(struct device *d,
>  	struct devfreq *df = to_devfreq(d);
>  	struct device *dev = df->dev.parent;
>  	struct dev_pm_opp *opp;
> +	unsigned int i = 0;
>  	ssize_t count = 0;
>  	unsigned long freq = 0;
>  
> -	rcu_read_lock();
> -	do {
> -		opp = dev_pm_opp_find_freq_ceil(dev, &freq);
> -		if (IS_ERR(opp))
> -			break;
> -
> -		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
> -				   "%lu ", freq);
> -		freq++;
> -	} while (1);
> -	rcu_read_unlock();
> +	if (df->profile->freq_table) {
> +		for (i = 0; i < df->profile->max_state; i++)
> +			count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
> +					   "%u ", df->profile->freq_table[i]);

You are hereby changing the semmantics of the original
available_frequencies node.

When a frequency/voltage pair has been disabled (opp_disable), probably
by opp_disable(), the frequency is no more "available".
However, when the driver author supplied freq_table as well as OPP
in order to see the statistics, the node will behave differently.

Please do not affect the current users as long as it does not give
additional benefit or fix a bug.


Cheers,
MyungJoo.


> +	} else {
> +		rcu_read_lock();
> +		do {
> +			opp = dev_pm_opp_find_freq_ceil(dev, &freq);
> +			if (IS_ERR(opp))
> +				break;
> +
> +			count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
> +					   "%lu ", freq);
> +			freq++;
> +		} while (1);
> +		rcu_read_unlock();
> +	}
>  
>  	/* Truncate the trailing space */
>  	if (count)
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
