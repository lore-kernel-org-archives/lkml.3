Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbaIWCLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:11:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29369 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbaIWCLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:11:30 -0400
X-AuditID: cbfee68d-f79296d000004278-75-5420d6cf6480
Message-id: <5420D6CE.7050606@samsung.com>
Date: Tue, 23 Sep 2014 11:11:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: myungjoo.ham@samsung.com, linux-pm@vger.kernel.org,
        kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        b.zolnierkie@samsung.com, nm@ti.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/5] devfreq: event: Add exynos-ppmu devfreq evnet
 driver
References: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
 <1409891419-28560-3-git-send-email-cw00.choi@samsung.com>
 <1410511274.31130.7.camel@x220>
In-reply-to: <1410511274.31130.7.camel@x220>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkSPf8NYUQg53PeC0er1nMZLFxxnpW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBZvfpxlslh06wyzxeMVb9kt
	Vu36w+jA67Fz1l12j8V7XjJ5bF5S79G3ZRWjx/Eb25k8Nm5/wuTxeZNcAHsUl01Kak5mWWqR
	vl0CV8aiprOsBSf4Km4+eMrWwHiDu4uRk0NCwETi498FTBC2mMSFe+vZuhi5OIQEljJK9HVt
	ZYUpOnXqESNEYhGjxKzn3VBVrxklFt5YwwZSxSugJfHm7wWwUSwCqhKXJ09hB7HZgOL7X9wA
	qxEVCJNYOf0KC0S9oMSPyffAbBEBZYnWzffYQYYyCxxjkrgycx/QOg4OYYFgic6TVhDLFjNK
	dP/4xwoS5xTQkXi62h6kl1lAXWLSvEXMELa8xOY1b5lB6iUEOjkk3i5bwgxxkIDEt8mHWEB6
	JQRkJTYdYIb4TFLi4IobLBMYxWYhOWkWkrGzkIxdwMi8ilE0tSC5oDgpvchQrzgxt7g0L10v
	OT93EyMwjk//e9a7g/H2AetDjAIcjEo8vB5rFEKEWBPLiitzDzGaAl0xkVlKNDkfmCzySuIN
	jc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgPPhh1oJKFyGd
	Z74X12Uz39RdeMH3YlpDPHOY+NH8RrulIrM1LGZXe0Z1tsf+5ftyqvqzzI1Vby5b5LHv+XD0
	0v3Ml/O/7BJvKlo5S/yORVyfZN9njodcUVuutLL+vznXfM4zodgcYW/b1QX+9Qd0rMSyPt3m
	WlQw3ybvULNT7f03qRzqmidtlFiKMxINtZiLihMBDvSM894CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd3z1xRCDK6uYLV4vGYxk8XGGetZ
	LXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWtxtXsFm8+XGWyWLRrTPMFo9XvGW3
	WLXrD6MDr8fOWXfZPRbvecnksXlJvUffllWMHsdvbGfy2Lj9CZPH501yAexRDYw2GamJKalF
	Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDnKimUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzFjWdZS04wVdx88FTtgbGG9xdjJwcEgImEqdO
	PWKEsMUkLtxbz9bFyMUhJLCIUWLW824o5zWjxMIba9hAqngFtCTe/L3ABGKzCKhKXJ48hR3E
	ZgOK739xA6xGVCBMYuX0KywQ9YISPybfA7NFBJQlWjffYwcZyixwjEniysx9QKs5OIQFgiU6
	T1pBLFvMKNH94x8rSJxTQEfi6Wp7kF5mAXWJSfMWMUPY8hKb17xlnsAoMAvJillIymYhKVvA
	yLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhJPJPawbiyweIQowAHoxIPr+cahRAh1sSy
	4srcQ4wSHMxKIrwlE4FCvCmJlVWpRfnxRaU5qcWHGE2BITCRWUo0OR+YwPJK4g2NTcyMLI3M
	DS2MjM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTAKGovVLXicrfzQ+eh3dZuMc0k1f0Nd
	D7Sl/Y7u/n93rornVFfbrsdMFhk6/J++Gog8SfcN/nDM4YTjDgHdwz+nHDCf/r05PM9a5Kme
	Fec0gROmfqd0GWdYhF+bvOqnjnrgHka7LgbpAyfmRmpEuKrvnl7o0HH3rujfVTOPq/qqhN68
	oabBIaLEUpyRaKjFXFScCAAfkmkHKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 09/12/2014 05:41 PM, Paul Bolle wrote:
> On Fri, 2014-09-05 at 13:30 +0900, Chanwoo Choi wrote:
>> This patch add exynos-ppmu devfreq event driver to provider raw data about
>> the utilization of each IP in Exynos SoC series.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/devfreq/Kconfig             |  10 +
>>  drivers/devfreq/event/Makefile      |   1 +
>>  drivers/devfreq/event/exynos-ppmu.c | 410 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 421 insertions(+)
>>  create mode 100644 drivers/devfreq/event/exynos-ppmu.c
>>
>> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
>> index ef839e7..4fbbcea 100644
>> --- a/drivers/devfreq/Kconfig
>> +++ b/drivers/devfreq/Kconfig
>> @@ -90,4 +90,14 @@ config ARM_EXYNOS5_BUS_DEVFREQ
>>  
>>  comment "DEVFREQ Event Drivers"
>>  
>> +config DEVFREQ_EVENT_EXYNOS_PPMU
>> +	bool "EXYNOS PPMU (Performance Profiling Monitoring Unit) DEVFREQ event Driver"
>> +	depends on ARCH_EXYNOS
>> +	select ARCH_HAS_OPP
> 
> This select statement can be dropped: see commit 78c5e0bb145d ("PM /
> OPP: Remove ARCH_HAS_OPP").

I'll drop it. 

> 
> By the way: there's a typo in the commit summary ("evnet").

My mistake, I'll fix typo.

Thanks for your review.
Chanwoo Choi

> 
>> +	select PM_OPP
>> +	help
>> +	 This add the DEVFREQ event driver for Exynos SoC. It provides PPMU
>> +	 (Performance Profiling Monitoring Unit) counters to estimate the
>> +	 utilization of each module.
>> +
>>  endif # PM_DEVFREQ
> 
> 
> Paul Bolle
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

