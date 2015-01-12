Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbbALKRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:17:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13939 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbALKRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:17:08 -0500
X-AuditID: cbfee68f-f791c6d000004834-b9-54b39f2159bb
Message-id: <54B39F21.3070602@samsung.com>
Date: Mon, 12 Jan 2015 19:17:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com, ABHILASH KESAVAN <a.kesavan@samsung.com>
Cc: "kgene@kernel.org" <kgene@kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
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
Subject: Re: [PATCHv7 00/10] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
References: <437622256.904751421056684753.JavaMail.weblogic@epmlwas01a>
In-reply-to: <437622256.904751421056684753.JavaMail.weblogic@epmlwas01a>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkRFdx/uYQg1ltxhaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJusWrXH0YHfo8189YweuycdZfdY/Gel0wem1Z1snlsXlLv0bdlFaPH501yAexR
	XDYpqTmZZalF+nYJXBm3tnxjKZjBU/Hgf2QD42/OLkZODgkBE4nPj5czQdhiEhfurWfrYuTi
	EBJYyigx/UYrO0xRy6fTrBCJ6YwSx+6eZYFwXjNK7Hr0lw2kildAS+Lp/jdgNouAqsTubyvB
	bDag+P4XN8BsUYEwiZXTr7BA1AtK/Jh8D8wWEXCT2Lb1MzPIUGaBh6wS08+sBrqJg0NYIE3i
	xREPkBohAXeJVVsXgNVzCnhIvN90hxnEZhZQl5g0bxGULS+xec1bsDkSAhM5JC7evs8OcZCA
	xLfJh1hAZkoIyEpsOsAM8ZmkxMEVN1gmMIrNQnLSLCRjZyEZu4CReRWjaGpBckFxUnqRsV5x
	Ym5xaV66XnJ+7iZGYFyf/vesfwfj3QPWhxgFOBiVeHgtpDaHCLEmlhVX5h5iNAW6YiKzlGhy
	PjB55JXEGxqbGVmYmpgaG5lbmimJ8y6U+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXF7
	FE/z9nuO8UqmTbu70pc9+uw/k//JiyUcSwwFbsv6fmu7/G7B4X1LzBkOMd3yOma/XPimosmJ
	Y34qFVknm5efK90h9EvCen16LPfqzLXC+sq/RPz0l7M2zE2dsevuro8K31r0F1Td8Cnk6Bee
	dicg4Kxekt+m8IaoDAW7r94Hd6gc9nuxKE2JpTgj0VCLuag4EQA0KToU5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV3F+ZtDDBZO0rZ4vGYxk8XGGetZ
	LSbdn8Bi8fqFoUX/49fMFmeb3rBbbHp8jdXi8q45bBafe48wWsw4v4/JYun1i0wWtxtXsFk8
	XvGW3aJ17xF2i1W7/jA68HusmbeG0WPnrLvsHov3vGTy2LSqk81j85J6j74tqxg9Pm+SC2CP
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYcWvLN5aCGTwVD/5HNjD+5uxi
	5OSQEDCRaPl0mhXCFpO4cG89WxcjF4eQwHRGiWN3z7JAOK8ZJXY9+ssGUsUroCXxdP8bMJtF
	QFVi97eVYDYbUHz/ixtgtqhAmMTK6VdYIOoFJX5Mvgdmiwi4SWzb+pkZZCizwENWielnVjN1
	MXJwCAukSbw44gFSIyTgLrFq6wKwek4BD4n3m+4wg9jMAuoSk+YtgrLlJTavecs8gVFgFpIV
	s5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcNJ4JrWDcWWDxSFGAQ5GJR5e
	C6nNIUKsiWXFlbmHGCU4mJVEeF3LgEK8KYmVValF+fFFpTmpxYcYTYEhMJFZSjQ5H5jQ8kri
	DY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGGPql7Pc81hz/X8+Z7yw
	0L8d88465hYY7gp6W/InYvPacwK2rx/+YFZNXqz6Nlf2Y+3R5ec+39T4tkws9JmDb6Zi8NV/
	joVcJYtl7FnX24WGVwpn9D2rMTvwmONZa9OjrSn5NV+n6TYad9XYb9ubcuDAa9nKgG/tt1c1
	sHs09Pfpc6VwTZ1UrcRSnJFoqMVcVJwIAJz7m7gwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 06:58 PM, MyungJoo Ham wrote:
>>   
>>  This patchset add new devfreq_event class to provide raw data to determine
>> current utilization of device  which is used for devfreq governor.
>>
>> The following description explains the feature of two kind of devfreq class:
>> - devfreq class (existing)
>>  : devfreq consumer device use raw data from devfreq_event device for
>>    determining proper current system state and change voltage/frequency
>>    dynamically using various governors.
>> - devfreq_event class (new)
>>  : Provide measured raw data to devfreq device for governor
>>
> 
> Question: Applying this patchset seems to imply that
> drivers/devfreq/exynos/exynos_ppmu.c becomes obsolete.
> How do you want to address it? Do you think it'd be ok to remove
> thse obsolete drivers after your successing patchset?
> 
> If it is ok to remove old drivers after applying the new patchset,
> please inclde a patch that removes old drivers unless such a removal
> might result in compatibility issues with old (yet another obsolete)
> board files, which I don't think probable.

I agree to remove 'drviers/devfreq/exynos/exynos_ppmu.c.
But, existing exynos_ppmu.c was used for drivers/devfreq/exynos/exynos5_bus.c.

Before removing existing 'exynos_ppmu.c', might need to test the devfreq-event class
on Exynos5260 SoC. I will just remove old driver('drivers/devfreq/exynos/exynos4_bus.{c|h}')
on next patchset.

To Abhilash,
Could you test this patch-set on Exynos5260 SoC?

Best Regards,
Chanwoo Choi

