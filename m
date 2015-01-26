Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbbAZCG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:06:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56770 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbbAZCG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:06:56 -0500
X-AuditID: cbfee68d-f79296d000004278-12-54c5a13ead41
Date: Mon, 26 Jan 2015 02:06:54 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: RE: [PATCH v9 0/7] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
To: Kukjin Kim <kgene@kernel.org>,
        =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>
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
X-MTR: 20150126020349434@myungjoo.ham
Msgkey: 20150126020349434@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150126020349434@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <298834569.29261422238011182.JavaMail.weblogic@epmlwas04d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkWNdu4dEQg+532haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjw+5bjAXH2Cu+/F7B2sC4gr2LkZNDSEBdYtGSk2xdjBwcEgIm
	Er9/xYKEJQTEJC7cWw8U5gIqWcoo8fTZclaIhInEmmuvGCEScxgllrfeAhvEIqAqsaB7EivI
	IDYBPYmZn5NBTGGBdIntv6RBKkQEMiQOf21jBWllFuhhk+i4+p0Z4gYliTX7XrGA2LwCghIn
	Zz5hgdilKnHz8BZ2iLiaxL6HfWwQcXGJC3MvsUPYvBIz2p9C1ctJTPu6hhnClpY4P2sDI8wz
	i78/horzSxy7vYMJwhaQmHrmIFSNlsSOfb+hfuSTWLPwLQtM/a5Ty5lhdt3fMheqV0Jia8sT
	sHpmAUWJKd0P2UH+ZRbQlFi/Sx/dK7wCbhI/Dt4Bh6eEwEQOiT/d/WwTGJVmIambhWTULIRR
	yEoWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAhMCqf/PevdwXj7gPUhRgEORiUeXo3G
	oyFCrIllxZW5hxhNgZE0kVlKNDkfmHrySuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGan
	phakFsUXleakFh9iZOLglGpgTFyQE952Y/Oy5gnbWaTudgjoX1rcl6CRIXt7TZdA3KOUiLij
	EzZUXIp5uu7vQZbDlzWvXznMXxpTHxRXu+DPGX8Wdyb/SQZ7zj30ZNvA+F9Ras/3vG3hyc8K
	DXZc1jbwLrvfy5xvunjNgSNv99hwcydMOfH9ukpLxU+ppywtyif39172Zlx3RYmlOCPRUIu5
	qDgRAFOvS6gFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tXl27hUdDDI61q1pc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIwP
	u28xFhxjr/jyewVrA+MK9i5GTg4hAXWJRUtOsoHYEgImEmuuvWKEsMUkLtxbDxTnAqqZwyix
	vPUWWAOLgKrEgu5JrF2MHBxsAnoSMz8ng5jCAukS239Jg1SICGRIHP7axgrSyizQwybRcfU7
	M8QuJYk1+16xgNi8AoISJ2c+YYHYpSpx8/AWdoi4msS+h31Q94hLXJh7iR3C5pWY0f4Uql5O
	YtrXNcwQtrTE+Vkb4G5e/P0xVJxf4tjtHUwQtoDE1DMHoWq0JHbs+80KYfNJrFn4lgWmftep
	5cwwu+5vmQvVKyGxteUJWD2zgKLElO6H7CD/MgtoSqzfpY/uFV4BN4kfB++wTWCUnYUkNQtJ
	9yyEbmQlCxhZVjGKphYkFxQnpVeY6BUn5haX5qXrJefnbmIEp6BnS3YwNlywPsQowMGoxMOr
	0Xg0RIg1say4MvcQowQHs5IIb/kUoBBvSmJlVWpRfnxRaU5q8SFGU2CUTWSWEk3OB6bHvJJ4
	Q2NjEzMTU0sTCwNTcyVx3v/nckOEBNITS1KzU1MLUotg+pg4OKUaGK+9m/s3W6ZYgXd1mLOb
	osjE/SuqLHY2p7wK+39SuG5rb5P8ytlxT4p1kjfO+7B6vbPdif5CTqdzGRaZMxQyzZS7b0qe
	/DDtmqSByIUFBgVWFcckWATm3hJ+3H4yNW/S30Tbl4f11U9XTbuvvmFutVLQRrWAVZ973i/o
	UjDs2PqoJeW99my9y0osxRmJhlrMRcWJANb4XIpXAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0Q275hq014166

>   
>  Chanwoo Choi wrote:
> > 
> Hi,
> 

[]

> > 
> > --
> 
> Looks good to me.
> 
> Myungjoo, shall I take DT changes in this series into Samsung tree?
> 
> 4/7 ARM: dts: Add PPMU dt node for Exynos3250 SoC
> 5/7 ARM: dts: Add PPMU dt node for Exynos4 SoCs
> 6/7 ARM: dts: exynos: Add PPMU node for Exynos3250-based Rinato/Monk board
> 7/7 ARM: dts: exynos: Add PPMU node for Exynos4412-based TRATS2 board

Yes, you may take those. I am not so confident with taking DT patches, either.

However, Chanwoo has another updates following for this patchset.

After that, I guess we can merge chanwoo's patchset splitted.



Cheers,
MyungJoo.

> 
> Thanks,
> Kukjin
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
