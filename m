Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaKYHHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:07:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60047 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaKYHHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:07:39 -0500
X-AuditID: cbfee68e-f79b46d000002b74-2e-54742ab9989b
Date: Tue, 25 Nov 2014 07:07:36 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2 2/3] PM / devfreq: tegra: add devfreq driver for Tegra
 Activity Monitor
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141125070538489@myungjoo.ham
Msgkey: 20141125070538489@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141125070538489@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <715439136.113681416899252854.JavaMail.weblogic@epmlwas08c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkSHenVkmIwa957BaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSuj+1UvY0EbV8X+192sDYwPOLsYOTmEBNQlFi05yQZiSwiYSNzZ
	fpoZwhaTuHBvPVCcC6hmKaPE1ref4Ipu/1nJApGYwyjRdfozWIJFQFViQXMDexcjBwebgJ7E
	zM/JIGFhgTiJGd++gQ0VEciQ2PZlDytIL7PAXBaJznX7mSCuUJJYs+8VC4jNKyAocXLmExaI
	ZaoSzRs3MELE1SSab3+CiotLXJh7iR3C5pWY0f4UKi4nMe3rGqgPpCXOz4LoBflm8ffHUHF+
	iWO3dzBB2AISU88chKrRkvh6ajvUTD6JNQvfssDU7zq1nBlm1/0tc6F6JSS2tjxhBbGZBRQl
	pnQ/BPudWUBTYv0ufXSv8Aq4S3T8WwgOUAmBXg6Jhc83Mk1gVJqFpG4WklGzEEYhK1nAyLKK
	UTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzAxnP73rG8H480D1ocYBTgYlXh4O84WhwixJpYV
	V+YeYjQFxtJEZinR5Hxg+skriTc0NjOyMDUxNTYytzRTEudNkPoZLCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoFxsTm/+Jz9Svemncr0K3jxpWXW1acqEUsnylr+CXrFaRPZaf5b2yDc8/GT
	jj/CMj4C3Be+R4T/OPv1X9GEPqlMrckbdwVxbDx8LVr4atLNScy7JE6svW7Y3vHhyZJABiY2
	wZNi7tY7Cs7Kvpk9K6G/Uv3h+ggtxbCX4rMeMm6TfRhz6b2GyYNCJZbijERDLeai4kQAMhBH
	tgcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t/tPt2dWiUhBovELC7vmsPmwOjxeZNc
	AGNUmk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0Ewl
	hbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1StKG5kZ6RgZ6pkZ6hcayVoYGBkSlQTUJaRver
	XsaCNq6K/a+7WRsYH3B2MXJyCAmoSyxacpINxJYQMJG4/WclC4QtJnHh3nqgOBdQzRxGia7T
	n8GKWARUJRY0N7B3MXJwsAnoScz8nAwSFhaIk5jx7RsziC0ikCGx7cseVpBeZoG5LBKd6/Yz
	QSxTkliz7xXYAl4BQYmTM59ALVOVaN64gREiribRfPsTVFxc4sLcS+wQNq/EjPanUHE5iWlf
	1zBD2NIS52dB9IIcvfj7Y6g4v8Sx2zuYIGwBialnDkLVaEl8PbUdaiafxJqFb1lg6nedWs4M
	s+v+lrlQvRISW1uesILYzAKKElO6H4L9ziygKbF+lz66V3gF3CU6/i1km8AoOwtJahaS7lkI
	3chKFjCyrGIUTS1ILihOSq8w1CtOzC0uzUvXS87P3cQITkHPFu5g/HLe+hCjAAejEg9v59ni
	ECHWxLLiytxDjBIczEoivFHzgEK8KYmVValF+fFFpTmpxYcYTYFxNpFZSjQ5H5ge80riDY2N
	TcxMTC1NLAxMzZXEef+fyw0REkhPLEnNTk0tSC2C6WPi4JRqYFQUixXOEuOxE5ulzHvvWYFq
	4vv305ojzT+ds9XpuXblv4a1qqjrIwHVyQxJ/xM950h4L8rdM7PxY3H2ybMcW8vsGif0Hs1l
	1HvAJt+VUTmntFjtnZX+K6szDGbK3ApPl+Y3u1hsmOsbtPejqeLhDRzHss67R03Zp3cialp1
	gpnQ1Pja2HNzlFiKMxINtZiLihMBUzw9QFcDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAP77nck003825

> The ACTMON block can monitor several counters, providing averaging and firing
> interrupts based on watermarking configuration. This implementation monitors
> the MCALL and MCCPU counters to choose an appropriate frequency for the
> external memory clock.
> 
> This patch is based on work by Alex Frid <afrid@nvidia.com> and Mikko
> Perttunen <mikko.perttunen@kapsi.fi>.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

How are you going to integrate other two patches?
May I just go ahead with this patch only?


Cheers,
MyungJoo.

> 
> ---
> 
> v2:	* Use devfreq
> ---
>  drivers/devfreq/Kconfig         |  10 +
>  drivers/devfreq/Makefile        |   1 +
>  drivers/devfreq/tegra-devfreq.c | 718 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 729 insertions(+)
>  create mode 100644 drivers/devfreq/tegra-devfreq.c
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
