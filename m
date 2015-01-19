Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbbASJg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:36:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15062 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbASJgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:36:23 -0500
X-AuditID: cbfee68f-f791c6d000004834-34-54bccfecb492
Date: Mon, 19 Jan 2015 09:35:40 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4 7/9] ARM: dts: Add the support for exynos busfreq on
 Exynos3250-based Rinato/Monk board
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>
Cc: =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        =?utf-8?Q?=EC=A1=B0=EC=98=81=EC=A4=80?= <yj44.cho@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150119093527797@myungjoo.ham
Msgkey: 20150119093527797@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150119093527797@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1074447423.1254841421660137637.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkRPfN+T0hBjv2mVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mma/OshYs4qqY/GABSwPjH84uRk4OIQF1iUVLTrKB2BICJhJX
	Dh5ihLDFJC7cWw8U5wKqWcooMfnvZBaYot5jr9khEnMYJZY+Ps8EkmARUJW4/n0mUIKDg01A
	T2Lm52QQU1ggT2LagVSQChEg88rdGYwgrcwCF9gk1hyczQRxhJLEmn2vwObzCghKnJz5BGqX
	qsS3P3PZIeJqEgff7mWHiItLXJh7CcrmlZjR/hSqXk5i2tc1zBC2tMT5WRvgnln8/TFUnF/i
	2O0dTBC2gMTUMweharQkfl9+CA0IPok1C9+ywNTvOrWcGWbX/S1zoXolJLa2PGEFsZkFFCWm
	dD8Ee51ZQFNi/S59dK/wCnhKtEy8wALyu4TARA6J3um32ScwKs1CUjcLyahZCKOQlSxgZFnF
	KJpakFxQnJReZKxXnJhbXJqXrpecn7uJEZgWTv971r+D8e4B60OMAhyMSjy8G3z3hAixJpYV
	V+YeYjQFRtJEZinR5Hxg8skriTc0NjOyMDUxNTYytzRTEuddKPUzWEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVAPjAdaIDy8s87/y7lLZ/kMwIbUk/cThSY98zmcbPrk5fdaFD+ssKtW69jHe
	URPa8qLJ8den6QKKsyZHTTfluL+TL4T/pOitcIWfD+cf274h9tusiZlMS3euPrrrxM/rf02D
	S4wzg9fV3HBeGrVUUHZrzlHboA97zlq9Sth+YGnXfoXzEzwnXXz4rkKJpTgj0VCLuag4EQBM
	M9bDBgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tPt035/eEGJxcomdxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jJm
	vjrLWrCIq2LygwUsDYx/OLsYOTmEBNQlFi05yQZiSwiYSPQee80OYYtJXLi3HijOBVQzh1Fi
	6ePzTCAJFgFVievfZwIVcXCwCehJzPycDGIKC+RJTDuQClIhAmReuTuDEaSVWeACm8Sag7OZ
	IHYpSazZ94oFxOYVEJQ4OfMJC8QuVYlvf+ayQ8TVJA6+3Qt1g7jEhbmXoGxeiRntT6Hq5SSm
	fV3DDGFLS5yftYER5ubF3x9Dxfkljt3ewQRhC0hMPXMQqkZL4vflh1D/8kmsWfiWBaZ+16nl
	zDC77m+ZC9UrIbG15QkriM0soCgxpfsh2OvMApoS63fpo3uFV8BTomXiBZYJjLKzkKRmIeme
	hdCNrGQBI8sqRtHUguSC4qT0CkO94sTc4tK8dL3k/NxNjOAU9GzhDsYv560PMQpwMCrx8G7w
	3RMixJpYVlyZe4hRgoNZSYSXbz1QiDclsbIqtSg/vqg0J7X4EKMpMMomMkuJJucD02NeSbyh
	sbGJmYmppYmFgam5kjjv/3O5IUIC6YklqdmpqQWpRTB9TBycUg2MmaFdC11NLR6nm5gazopf
	lvjiL6dM9LLOyZVfwv4u4n54fOqfWS8XhvP/v79hW6CK5J9pD9OmBZhJ9KxZULSuT2n7/dvr
	665cmHNwpaQg68eg+8UR8hUZG0JDo5RY/DdNvDKVWWdbcuDZd9JO+TUJh7Zc4OH9UaGxyeH/
	OQVd2bSY33s2zjjzVYmlOCPRUIu5qDgRAK8HNVRXAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J9aWkQ001832

>   
>  This patch adds the Exynos3250 memory-bus node which includes the regulator
> and devfreq-event phandle. The devfreq-event phandle is used for the
> governor of devfreq device and provide the current usage state of
> MIF (Memory Interface) / INT (Internal) memory bus group.
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Youngjun Cho <yj44.cho@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

I am not so confident with this SoC as I didn't write any kernel codes
for Exynos3250 devices. Anyway, as the syntax and usage appears good to me.

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  arch/arm/boot/dts/exynos3250-monk.dts   | 12 ++++++++++++
>  arch/arm/boot/dts/exynos3250-rinato.dts | 12 ++++++++++++
>  2 files changed, 24 insertions(+)
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
