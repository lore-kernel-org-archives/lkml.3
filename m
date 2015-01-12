Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbbALIjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:39:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:44294 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbbALIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:39:31 -0500
X-AuditID: cbfee68f-f791c6d000004834-de-54b3884026d7
Message-id: <54B38840.9080308@samsung.com>
Date: Mon, 12 Jan 2015 17:39:28 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCHv7 04/10] devfreq: event: Add exynos-ppmu devfreq-event
 driver
References: <603055177.891931421049871049.JavaMail.weblogic@epmlwas09a>
In-reply-to: <603055177.891931421049871049.JavaMail.weblogic@epmlwas09a>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkRNehY3OIwcMfNhaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJusWrXH0YHfo8189YweuycdZfdY/Gel0wem1Z1snlsXlLv0bdlFaPH501yAexR
	XDYpqTmZZalF+nYJXBnnr59gL5jCUXG7vaiB8RJbFyMnh4SAicSGl+9ZIGwxiQv31oPFhQSW
	Mkq8P+fUxcgBVrP3WmYXIxdQeDqjROPx52wQzmtGibUv/4I18ApoSWz5eIANpIFFQFVi6g0T
	kDAbUHj/ixtgJaICYRIrp19hgSgXlPgx+R6YLSIgI3F143YWkJnMAr1sEu/WL2IGSQgLBEvs
	+zifEeIgd4ljvfNZQWxOAQ+JJ7v+gtnMAuoSk+ZB1DMLyEtsXvOWGWSQhMBEDolnu3aCFbEI
	CEh8m3yIBeIbWYlNB5ghHpaUOLjiBssERrFZSG6ahWTsLCRjFzAyr2IUTS1ILihOSi8y1itO
	zC0uzUvXS87P3cQIjOnT/57172C8e8D6EKMAB6MSD6+F1OYQIdbEsuLK3EOMpkBXTGSWEk3O
	ByaOvJJ4Q2MzIwtTE1NjI3NLMyVx3oVSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MGbV
	Rq+29ddg8cqJuvRPV0xjfpJXmx+3ZVPrirmHblq7fbA169317eehK3Mv9tXedo2p+f3H7LV+
	wieXsG/i7LV8x29/0tp9/N2HAlGLMJapARsDpbbIt3O+jO61Y3nqtmu+zNm3mg4xxTd/P5Lg
	vs8k2BzwbFP6SvYPpxdYWSxQ1suzsJJ4ocRSnJFoqMVcVJwIANW85avkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQV2Hjs0hBqefmFg8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bFrVyeaxeUm9R9+WVYwenzfJBbBH
	NTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDdraRQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMOH/9BHvBFI6K2+1FDYyX2LoY
	OTgkBEwk9l7L7GLkBDLFJC7cWw8U5uIQEpjOKNF4/DmU85pRYu3Lv2wgVbwCWhJbPh4Aa2YR
	UJWYesMEJMwGFN7/4gZYiahAmMTK6VdYIMoFJX5MvgdmiwjISFzduJ0FZCazQC+bxLv1i5hB
	EsICwRL7Ps5nBLGFBNwljvXOZwWxOQU8JJ7s+gtmMwuoS0yaB1HPLCAvsXnNW+YJjAKzkOyY
	haRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCU8YzqR2MKxssDjEKcDAq8fBa
	SG0OEWJNLCuuzD3EKMHBrCTC61oGFOJNSaysSi3Kjy8qzUktPsRoCgyBicxSosn5wHSWVxJv
	aGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAaNSX0f2TzTiluqrK3kyJ
	80YSy4xDmyUSFxn4uAVVPyj2e5I+5UD45ZYlrEssU48//7LykQDrHpsHAhO+m+3oyur7cyba
	7UrWtT9JJ8znVcd6ffS5LvdpoYt654btzyMzrxvP/HQ6P0N01bGFvl3nLZXeulZ72CuUuHs9
	bitPeCKUvmXuoVkflViKMxINtZiLihMBMX4GsC8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo,

On 01/12/2015 05:04 PM, MyungJoo Ham wrote:
>>   
>>  This patch adds exynos-ppmu devfreq-event driver to get performance data
>> of each IP for Samsung Exynos SoC. These event from Exynos PPMU provide
>> useful information about the behavior of the SoC that you can use when
>> analyzing system performance, and made visible and can be counted using
>> logic in each IP.
>>
>> This patch is based on existing drivers/devfreq/exynos/exynos-ppmu.c
>>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/devfreq/event/Kconfig       |   9 +
>>  drivers/devfreq/event/Makefile      |   1 +
>>  drivers/devfreq/event/exynos-ppmu.c | 399 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 409 insertions(+)
>>  create mode 100644 drivers/devfreq/event/exynos-ppmu.c
>>
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> 

Thanks for your reviw.

Best Regards,
Chanwoo Choi
