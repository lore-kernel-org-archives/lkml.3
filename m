Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaLJMeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:34:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41645 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbaLJMer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:34:47 -0500
X-AuditID: cbfee68e-f79b46d000002b74-94-54883de554b5
Message-id: <54883DE4.5000907@samsung.com>
Date: Wed, 10 Dec 2014 21:34:44 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sameo@linux.intel.com, lee.jone@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com
Subject: Re: [PATCH v8 1/4] mfd: rt5033: Add Richtek RT5033 driver core.
References: <1418126634-4781-1-git-send-email-beomho.seo@samsung.com>
 <1418126634-4781-2-git-send-email-beomho.seo@samsung.com>
 <20141209140102.GZ3951@x1> <54882255.9060303@samsung.com>
 <20141210121331.GD23481@x1>
In-reply-to: <20141210121331.GD23481@x1>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0iTURj27Lv4uRyebOrRymiVppDmZXqiMsGCr3+G/oj8oWt+TPG2tilJ
	EFZaZrnmpZQhmoWpYxK5ylpaOpUQZVmTVExn4YXKmOEtL0RuK/Lfw/s+txdehvBcIf2Y9GwV
	p8iWZIpoPqkXRl44NH28OPGwpkmA736eovHw4iyFy6dsBK7rMVO4rLmCwHfm6im8oSmisflb
	M8DlVg2Jbe0DAFuXegFeHirmYYuxhsYLpT0ANwy/52FNVQuJizp6XHH/LQr3v1Lh6oqvdKyQ
	1dfqAWtRl/LYl9pxV7a5cZFmDU3BbKvuJs1++thOs7V9Z1j1Ux1gF1r94/nn+MdSucz0PE4R
	GpPCTyuqMfHkNfCiZdRMFQC1oAS4MQhGopn6D6QTe6PBicd0CeAznrABIOOXQeofyWRc5DkX
	VQCNmef/sr4DtG59uylnGAEMRpWPgF1AwgPI0NfmwDQMQrbKIUeCFzyL5nVLtB0L4Hb0q2LC
	IRXC/cg8F223JGA3gepmrcA+3wFZ9PBqgDNqDKC1ug5HITd4EDWqNyg7h4CBqLIyyz4m4B5k
	0P8g7HwEhxhUa2uknH0gWq4wObIQ3I1aOwnnXb6oq2mE1ABv7ZZG2v+u2i2u9wGhA16cXCpX
	npcpwkOUkixlbrYsRJqT1Qo2/6H/94z6BRjtPGoCkAEid0G85UaiJyXJU+ZnmYB4s0QZ4ecl
	zdl8oWxVclhEVDgWR4ojwqOPRIl8BCl+qwmeUCZRcRkcJ+cUyYrcTE5pAjzGza8AxK2ryVWX
	9L1tkzuj49Ze+1I/LXrbvaaChYjn1UkZhcVvTjxxO22ITNDW7QuNkZ4STvbKeXRs4kLISOPJ
	B2JrjruH2Mc4Pp2JdwXNFr6LyI3uMrYR3LPLnS0BDdfyV67rSgaScgTdqaHbrrj49whFS+Wy
	KqXBR1gGWi553A4OFJHKNElYMKFQSv4A8AuzpQoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd2nth0hBjdOMFtMffiEzeL6l+es
	FpOevGe2mH/kHKvFxJWTmS363yxktfgzoZXN4tyrlYwWk+5PYLF4v+cMo8X9r0cZLb5d6WCy
	uLxrDpvF594jjBZLr19kspgwfS2LReveI+wWp7tZLU7vLrGYMfklm4OIx5p5axg9Lvf1Mnns
	nHWX3WPl8i9sHptXaHlsWtXJ5nHn2h42j3knAz36tqxi9Pi8SS6AK6qB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DslhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY0brnENMBXMEKi7fPMfawNjH28XIySEhYCJxaNcXJghb
	TOLCvfVsXYxcHEIC0xklbp/7AOW8ZpT4ff84SxcjBwevgJbElGWMIA0sAqoSm09uB7PZBDQl
	3k+5wgJiiwpESHxY9ZUNxOYVEJT4MfkeWKuIgIrEuTfmICOZBQ4zS8x/fp8RJC4s4CGxuEkN
	YtVtRolf8/eygvRyCmhILO/7wwpSwyygLjFlSi5ImFlAXmLzmrfMExgFZiHZMAuhahaSqgWM
	zKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgpPPM6kdjCsbLA4xCnAwKvHwBlxuDxFiTSwr
	rsw9xCjBwawkwvtGsiNEiDclsbIqtSg/vqg0J7X4EKMp0P8TmaVEk/OBiTGvJN7Q2MTMyNLI
	3NDCyNhcSZxXyb4tREggPbEkNTs1tSC1CKaPiYNTqoFxUqD4DT/j2fe/mKzOnGpcsyDY4syp
	pLZa5+CTz4Ta8t505esmKa62PeJo4/NabZGsWMZuf0HD55FPlERWN15pmrz0NtOVDYs0DAP+
	mv7ZvKU9L3qiwNHvHDeM61tYz+jc7a98Fsz4T2zTolVK6xsPLnnUv8KqguHly+8Czdz6evue
	mG2r765XYinOSDTUYi4qTgQAuN/qcVQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 09:13 PM, Lee Jones wrote:
> On Wed, 10 Dec 2014, Beomho Seo wrote:
> 
>> On 12/09/2014 11:01 PM, Lee Jones wrote:
>>> On Tue, 09 Dec 2014, Beomho Seo wrote:
>>>
>>>> This patch adds a new driver for Richtek RT5033 driver.
>>>> RT5033 is a Multifunction device which includes battery charger, fuel gauge,
>>>> flash LED current source, LDO and synchronous Buck converter. It is interfaced
>>>> to host controller using I2C interface.
>>>>
>>>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>>>> Cc: Lee Jones <lee.jone@linaro.org>
>>>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
>>>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> ---
>>>>  drivers/mfd/Kconfig                |   12 ++
>>>>  drivers/mfd/Makefile               |    1 +
>>>>  drivers/mfd/rt5033.c               |  142 ++++++++++++++++++++
>>>>  include/linux/mfd/rt5033-private.h |  260 ++++++++++++++++++++++++++++++++++++
>>>>  include/linux/mfd/rt5033.h         |   62 +++++++++
>>>>  5 files changed, 477 insertions(+)
>>>>  create mode 100644 drivers/mfd/rt5033.c
>>>>  create mode 100644 include/linux/mfd/rt5033-private.h
>>>>  create mode 100644 include/linux/mfd/rt5033.h
>>>
>>> Much better.
>>>
>>> For my own reference:
>>>
>>> Acked-by: Lee Jones <lee.jones@linaro.org>
>>>
>>> So what's the plan with this set?
>>>
>>
>> This patch have been made on for-next-mfd branch of your git repository.
>> So I hope this patch to be merged at your git repository.
>> Another patch set(RT5033 regulator driver) have been merged on for-next branch of regulator git repository.
>>
>> https://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/commit/?h=for-next&id=b1917578fd5d8efa67afa05a0d6d7e323f2802da
>>
>> Other patches(about charger, fuelgague and devicetree doc) will be re-sent to each maintainers.
> 
> Okay, so all patches are indipendant/othognal of each other for sure?
> 

Yes, rt5033 core driver merge before other patches with no problem.
It is do not have dependency other patches.


Best regards,
Beomho Seo
