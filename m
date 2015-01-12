Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbbALJuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:50:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9052 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbbALJt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:49:58 -0500
X-AuditID: cbfee68d-f79296d000004278-d6-54b398c200c1
Date: Mon, 12 Jan 2015 09:49:54 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv7 07/10] ARM: dts: Add PPMU dt node for Exynos4 SoCs
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
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150112094944746@myungjoo.ham
Msgkey: 20150112094944746@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150112094944746@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1120420862.904031421056191722.JavaMail.weblogic@epmlwas01a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkUPfQjM0hBv0PrSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGpJ3nmQpm8FTM3jifpYHxDXcXIyeHkIC6xKIlJ9lAbAkBE4n1
	Z16zQthiEhfurQeKcwHVLGWUmPLhOVzRlxNtUIk5jBJXdp9nB0mwCKhK/N3XAGRzcLAJ6EnM
	/JwMEhYW8JBou3EarEREIE/iyt0ZjCC9zAI9bBIdV78zQ1yhJLFm3ysWEJtXQFDi5MwnLBDL
	VCXO3LrNChFXk2g88pAZIi4ucWHuJXYIm1diRvtTqHo5iWlf10DVSEucn7WBEeabxd8fQ8X5
	JY7d3sEEYQtITD1zEKpGS+JX6z2oJ/kk1ix8ywJTv+vUcmaYXfe3zIXqlZDY2vIE7DZmAUWJ
	Kd0PwX5nFtCUWL9LH90rvMBw6L6xjBnkdwmBiRwS2/v+sk1gVJqFpG4WklGzEEYhK1nAyLKK
	UTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzAxnP73rHcH4+0D1ocYBTgYlXh4LaQ2hwixJpYV
	V+YeYjQFxtJEZinR5Hxg+skriTc0NjOyMDUxNTYytzRTEudVlPoZLCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoHRed+v6AvK937duruycMMhjV8RG1XfeLjelF0nmXhk+uNttpdrHK0rC7q8
	ctXnK4cWWCxVXvj8zvU00+2ecebhC17Zv+VQPzNrcoK3eeK5H6neYpYTk65or8/T11FwaMwT
	9fXOLkiWiJWQEJ4oM7mo7UDyogXTejgOvYuWutBo9UVh4Yu5sxOVWIozEg21mIuKEwEc5Ca3
	BwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t/tPt1DMzaHGBz6Z2hxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jIm
	7TzPVDCDp2L2xvksDYxvuLsYOTmEBNQlFi05yQZiSwiYSHw50QZli0lcuLceyOYCqpnDKHFl
	93l2kASLgKrE330NQDYHB5uAnsTMz8kgYWEBD4m2G6fBSkQE8iSu3J3BCNLLLNDDJtFx9Tsz
	xDIliTX7XrGA2LwCghInZz5hgVimKnHm1m1WiLiaROORh8wQcXGJC3MvsUPYvBIz2p9C1ctJ
	TPu6BqpGWuL8rA2MMEcv/v4YKs4vcez2DiYIW0Bi6pmDUDVaEr9a70E9ySexZuFbFpj6XaeW
	M8Psur9lLlSvhMTWlidgtzELKEpM6X4I9juzgKbE+l366F7hBYZD941lzBMYZWchSc1C0j0L
	oRtZyQJGllWMoqkFyQXFSekVJnrFibnFpXnpesn5uZsYwUno2ZIdjA0XrA8xCnAwKvHwWkht
	DhFiTSwrrsw9xCjBwawkwutaBhTiTUmsrEotyo8vKs1JLT7EaAqMs4nMUqLJ+cAEmVcSb2hs
	bGJmYmppYmFgaq4kzvv/XG6IkEB6YklqdmpqQWoRTB8TB6dUA6OvPNedpEAXFnEbr8emvIvT
	v3+9dEP+xp5opoNSd3YYRy13PL375/2Oxa9ni87PnHu181bjz7TX65rumrHs/Zpy/31DQ2zI
	oZLkLZbODxa93saeuLb6CtuxH7WpSzRV5nx5t05twaKFZ3TmefBtnns+0K/xlVmicv2sF2Lr
	80tMZokye20+s9NRiaU4I9FQi7moOBEAoOXIfVgDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0C9o6s0017173

>   
>  This patch add PPMU (Platform Performance Monitoring Unit) dt node for Exynos4
> (Exynos4210/4212/4412) SoC. PPMU dt node is used to monitor the utilization of
> each IP.
> 
> The Exynos4210/Exynos4212/Exynos4412 SoC includes following PPMUs:
> - PPMU_DMC0      0x106A_0000
> - PPMU_DMC1      0x106B_0000
> - PPMU_CPU       0x106C_0000
> - PPMU_ACP       0x10AE_0000
> - PPMU_RIGHT_BUS 0x112A_0000
> - PPMU_LEFT_BUS  0x116A_0000
> - PPMU_FSYS      0x1263_0000
> - PPMU_LCD0      0x11E4_0000
> - PPMU_CAMIF     0x11AC_0000
> - PPMU_IMAGE     0x12AA_0000
> - PPMU_TV        0x12E4_0000
> - PPMU_3D        0x1322_0000
> - PPMU_MFC_LEFT  0x1366_0000
> - PPMU_MFC_RIGHT 0x1367_0000
> 
> Additionally, the Exynos4210 SoC includes following PPMUs:
> - PPMU_LCD1      0x1224_0000
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4.dtsi    | 108 ++++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/exynos4210.dtsi |   8 +++
>  2 files changed, 116 insertions(+)
> 

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
