Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbbALJsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:48:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8856 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbbALJsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:48:36 -0500
X-AuditID: cbfee68d-f79296d000004278-10-54b39872e910
Date: Mon, 12 Jan 2015 09:48:34 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv7 06/10] ARM: dts: Add PPMU dt node for Exynos3250 SoC
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
X-MTR: 20150112094759699@myungjoo.ham
Msgkey: 20150112094759699@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150112094759699@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <673354552.903841421056111417.JavaMail.weblogic@epmlwas01a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkWLdoxuYQg4frLSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGY8MCxoJpnBW7//YxNTB+4ehi5OQQElCXWLTkJBuILSFgIrF6
	5nYWCFtM4sK99UBxLqCapYwSSz+8YoQperhtKTtEYg6jRNPH5awgCRYBVYm5m+YwdzFycLAJ
	6EnM/JwMEhYW8JL4/XwzWImIQJ7ElbszGEF6mQV62CQ6rn5nhrhCSWLNvldgm3kFBCVOznwC
	dYWqxOaPh5gg4moSi7s+sEPExSUuzL0EZfNKzGh/ClUvJzHt6xpmCFta4vysDYww3yz+/hgq
	zi9x7PYOJghbQGLqmYOMIDdLCGhJPFiaChHmk1iz8C0LTPmuU8uZYVbd3zIXqlVCYmvLE7C/
	mAUUJaZ0P2QHGcMsoCmxfpc+uk94BdwlGt9MZQF5XUJgJofEze2v2SYwKs1CUjcLyahZCKOQ
	lSxgZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJEZgWTv971ruD8fYB60OMAhyMSjy8FlKb
	Q4RYE8uKK3MPMZoCI2kis5Rocj4w+eSVxBsamxlZmJqYGhuZW5opifMqSv0MFhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cC4z8dSaf9ShsnJay32JNYZax6MqjzXGfeD82P8bpcZ0Qs2r+OX
	Plb2IfT5GuGnN1LD0o9PEZU9e+Rx09ErZXp3szgFotoXPU4qXhKgwSNVdK3Y69BZN6EV3vcy
	ZLw7c6VWtMznlVaaolIeMTV00uWVJ6KX3d50eL7rw4s2P2P9Is4FfLN5vtBGiaU4I9FQi7mo
	OBEAafimWQYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tXt2iGZtDDB5PN7S4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRmN
	DQsYC6ZxVuz+28fUwPiFo4uRk0NIQF1i0ZKTbCC2hICJxMNtS9khbDGJC/fWA8W5gGrmMEo0
	fVzOCpJgEVCVmLtpDnMXIwcHm4CexMzPySBhYQEvid/PN4OViAjkSVy5O4MRpJdZoIdNouPq
	d2aIZUoSa/a9YgGxeQUEJU7OfMICsUxVYvPHQ0wQcTWJxV0foI4Ql7gw9xKUzSsxo/0pVL2c
	xLSva5ghbGmJ87M2MMIcvfj7Y6g4v8Sx2zuYIGwBialnDjKC3CwhoCXxYGkqRJhPYs3Ctyww
	5btOLWeGWXV/y1yoVgmJrS1PwP5iFlCUmNL9kB1kDLOApsT6XfroPuEVcJdofDOVZQKj7Cwk
	qVlIumchdCMrWcDIsopRNLUguaA4Kb3CSK84Mbe4NC9dLzk/dxMjOAU9W7SD8d9560OMAhyM
	Sjy8FlKbQ4RYE8uKK3MPMUpwMCuJ8LqWAYV4UxIrq1KL8uOLSnNSiw8xmgKjbCKzlGhyPjA9
	5pXEGxobm5iZmFqaWBiYmiuJ8/4/lxsiJJCeWJKanZpakFoE08fEwSnVwHhPgvssR6NtytYN
	ttteubdv6Hpm8UV86iG752UKyfdnMS4/tOG3w4V2gaJHm37ItT7aMsNcc/NjC6/oSyt3LxHd
	X/Qq5UAnS3L+5Uea30Q1r3373Z/VFOIudeT1A5+t/TJscyeEh108zrJgXT0jP6uZwRR7tpTD
	G25cX318xiGFucxBMz1uX7moxFKckWioxVxUnAgAQPEht1cDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0C9mjOl017169

>   
>  This patch add PPMU (Platform Performance Monitoring Unit) dt node
> to estimate the utilization of each IP in Exynos SoC throught DEVFREQ Event
> subsystem.
> 
> This patch adds following PPMU dt nodes:
> - PPMU_DMC0     0x106a0000
> - PPMU_DMC1     0x106b0000
> - PPMU_RIGHTBUS 0x112A0000
> - PPMU_LEFTBUS  0x116A0000
> - PPMU_CAMIF    0x11AC0000
> - PPMU_LCD0     0x11E40000
> - PPMU_FSYS     0x12630000
> - PPMU_3D       0x13220000
> - PPMU_MFC      0x13660000
> - PPMU_CPU      0x106c0000
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250.dtsi | 74 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
