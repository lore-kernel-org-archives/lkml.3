Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbbALIEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:04:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43042 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbALIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:04:35 -0500
X-AuditID: cbfee68d-f79296d000004278-d2-54b380128624
Date: Mon, 12 Jan 2015 08:04:34 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv7 04/10] devfreq: event: Add exynos-ppmu devfreq-event
 driver
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
X-MTR: 20150112080349166@myungjoo.ham
Msgkey: 20150112080349166@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150112080349166@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <603055177.891931421049871049.JavaMail.weblogic@epmlwas09a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkRFeoYXOIwfpvchaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj5tmKghucFSfWLWBvYNzC2cXIySEkoC6xaMlJNhBbQsBE4u3d
	s+wQtpjEhXvrgeJcQDVLGSXOntrFClP0ec4TqMQcRom3W+YygyRYBFQlZndOYOpi5OBgE9CT
	mPk5GSQsLBAosWHtZBYQW0QgT+LK3RmMIL3MAj1sEh1XvzNDXKEksWbfK7AiXgFBiZMzn7BA
	LFOV+La7nQ0iriYxafEPRoi4uMSFuZegLuWVmNH+FKpeTmLa1zXMELa0xPlZGxhhvln8/TFU
	nF/i2O0dTBC2gMTUMweharQk5vz/A2XzSaxZ+JYFpn7XqeXMMLvub5kL1SshsbXlCThQmAUU
	JaZ0P2QH+Z1ZQFNi/S59dK/wCrhLLP35GWrkVA6JXf/FJjAqzUJSNgvJpFkIk5CVLGBkWcUo
	mlqQXFCclF5kqFecmFtcmpeul5yfu4kRmBRO/3vWu4Px9gHrQ4wCHIxKPLwWUptDhFgTy4or
	cw8xmgIjaSKzlGhyPjD15JXEGxqbGVmYmpgaG5lbmimJ8ypK/QwWEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwOiivmqRzL3zW0z1Hpfe7ot140ss/MHzKDBg45qX19cy+1YujOl6YXKKNTx4
	ulrwtAlqSQtO8VXz3g5LX94y/5PyvLnPv0hmfnq89rG3MXNmUjdr1d/Wtg+M3Ypn11iv+8l+
	va/DaNGBSbvWFradroleXxZ78PZP4YCSE3kMsc/3JVZxS7hoXlRiKc5INNRiLipOBABa1Ypp
	BQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tfl2hhs0hBs9/iFtc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIyZ
	ZysKbnBWnFi3gL2BcQtnFyMnh5CAusSiJSfZQGwJAROJz3OeQNliEhfurQeyuYBq5jBKvN0y
	lxkkwSKgKjG7cwJTFyMHB5uAnsTMz8kgYWGBQIkNayezgNgiAnkSV+7OYATpZRboYZPouPqd
	GWKZksSafa/AingFBCVOznzCArFMVeLb7nY2iLiaxKTFPxgh4uISF+ZeYoeweSVmtD+FqpeT
	mPZ1DTOELS1xftYGRpijF39/DBXnlzh2ewcThC0gMfXMQagaLYk5//9A2XwSaxa+ZYGp33Vq
	OTPMrvtb5kL1SkhsbXnCCmIzCyhKTOl+yA7yO7OApsT6XfroXuEVcJdY+vMzywRG2VlIUrOQ
	dM9C6EZWsoCRZRWjaGpBckFxUnqFsV5xYm5xaV66XnJ+7iZGcAp6tngH4//z1ocYBTgYlXh4
	LaQ2hwixJpYVV+YeYpTgYFYS4XUtAwrxpiRWVqUW5ccXleakFh9iNAXG2URmKdHkfGB6zCuJ
	NzQ2NjEzMbU0sTAwNVcS5/1/LjdESCA9sSQ1OzW1ILUIpo+Jg1OqgTGi8oO+K9vR7tueEvEL
	/xvuO3rZvj6Or/B2aHBC6MHcAK/oq29WHZLp3x7G4Pwx9sqNu5qPVY2ONZ3WKO7oufF9+mbd
	wOuJzOYZS04ser7GnLuw+dixTv2ywj9uM11n1s3WfRX+Nfq7fsj07x1T52iHi88+XsSSOzV9
	YXE+T9cDi3MiP1vOWSqxFGckGmoxFxUnAgDGfl77VwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0C84uLk016434

>   
>  This patch adds exynos-ppmu devfreq-event driver to get performance data
> of each IP for Samsung Exynos SoC. These event from Exynos PPMU provide
> useful information about the behavior of the SoC that you can use when
> analyzing system performance, and made visible and can be counted using
> logic in each IP.
> 
> This patch is based on existing drivers/devfreq/exynos/exynos-ppmu.c
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/event/Kconfig       |   9 +
>  drivers/devfreq/event/Makefile      |   1 +
>  drivers/devfreq/event/exynos-ppmu.c | 399 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 409 insertions(+)
>  create mode 100644 drivers/devfreq/event/exynos-ppmu.c
> 

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
