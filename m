Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaCQBho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:37:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33860 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaCQBhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:37:41 -0400
X-AuditID: cbfee68f-b7f156d00000276c-01-532651e3d3a8
Message-id: <532651E5.6040903@samsung.com>
Date: Mon, 17 Mar 2014 10:37:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, kgene.kim@samsung.com
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 0/5] ARM: dts: exynos: Add missing dt data to bring
 kernel of Exynos4x12
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
 <53204328.7070607@samsung.com> <53211071.4040408@samsung.com>
In-reply-to: <53211071.4040408@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsWyRsSkUPdxoFqwwaMf5hbzj5xjtTj3aiWj
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12Lp9YtMFhOmr2WxeHWwjcVi/YzXLA48
	HmvmrWH0aGnuYfNYufwLm8fmJfUefVtWMXp83iTnsXFuaAB7FJdNSmpOZllqkb5dAlfG9Jdn
	WQo+CVX0vjvD1MC4ir+LkZNDQsBE4vDEbcwQtpjEhXvr2boYuTiEBJYySjz/8JwRpuhzx0cm
	iMQiRomFvTdZIJxXjBIHdzxjA6niFdCS+HF5CzuIzSKgKnHj1xGwOBtQfP+LG2C2qECYxMrp
	V1gg6gUlfky+B2RzcIgIWEv8nuIBMpNZYAGTxL8lzawgNcICCRILZixghljWwiix7tUcsFs5
	BbQl7jQ9BitiFtCR2N86jQ3ClpfYvOYtWIOEQCOHxN5Fb9ggLhKQ+Db5ENg2CQFZiU0HoH6W
	lDi44gbLBEaxWUhumoVk7CwkYxcwMq9iFE0tSC4oTkovMtYrTswtLs1L10vOz93ECIzd0/+e
	9e9gvHvA+hBjMtDKicxSosn5wNjPK4k3NDYzsjA1MTU2Mrc0I01YSZz3/sOkICGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2Mk498+i4y46rmhIRL9p8+P7ptaT1rfbLRjttZArUJEhvP/Yp+
	G9jMl8mdXcCbzmppf2eztzb/8Yj21XuvNj5KX/Zqkuu0y6fOM8gWyTUvvMmzsu75ruVqLZwm
	d0zjvvs/Y77DtMm/5HDm50/tE77M+yxfPbfuH0Ov3curtx8lOSTva/sg9Ux/rxJLcUaioRZz
	UXEiAP7ZPe7zAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd3HgWrBBi+WGFjMP3KO1eLcq5WM
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZlXoul1y8yWUyYvpbF4tXBNhaL9TNeszjw
	eKyZt4bRo6W5h81j5fIvbB6bl9R79G1ZxejxeZOcx8a5oQHsUQ2MNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAdyoplCXmlAKFAhKLi5X07TBNCA1x
	07WAaYzQ9Q0JgusxMkADCWsYM6a/PMtS8EmoovfdGaYGxlX8XYycHBICJhKfOz4yQdhiEhfu
	rWfrYuTiEBJYxCixsPcmC4TzilHi4I5nbCBVvAJaEj8ub2EHsVkEVCVu/DoCFmcDiu9/cQPM
	FhUIk1g5/QoLRL2gxI/J94BsDg4RAWuJ31M8QGYyCyxgkvi3pJkVpEZYIEFiwYwFzBDLWhgl
	1r2awwyS4BTQlrjT9BisiFlAR2J/6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEJ4Zn0jsYVzVYHGIU4GBU4uGdoKwWLMSaWFZcmXuIUYKD
	WUmEN8EcKMSbklhZlVqUH19UmpNafIgxGRgEE5mlRJPzgUkrryTe0NjEzMjSyNzQwsjYnDRh
	JXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYKy8e+POB71RVTJmw3KOGhwIN3vWWx5bIsk/I
	jHy0PF2/pG+qtWyZylc7zd+eNfUKAoVMxzZ3Vpay7d0i1rjmnZNk5f4zbw7v7DP24DEsNgrN
	a9ZY2ObF5iE9k+1hivkG60szTv11m9Exxd7OzW2itPvSCYFX/tSpSDiWxXalKe2Yyt6/aooS
	S3FGoqEWc1FxIgASvSZGUAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

Ping.

Please review this patchset.

Best Regards,
Chanwoo Choi

On 03/13/2014 10:57 AM, Chanwoo Choi wrote:
> Dear Kukjin,
> 
> On 03/12/2014 08:21 PM, Tomasz Figa wrote:
>> Hi Chanwoo,
>>
>> On 12.03.2014 07:19, Chanwoo Choi wrote:
>>> This patch add missing dt data of Exynos4x12 to bring up kernel feature and
>>> code clean. This patchset is based on 'v3.15-next/dt-clk-exynos' branch.
>>> - git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
>>>
>>> exynos4x12/exynos4412/exynos4212.dtsi
>>> - Add ADC (Analog and Digital Converter) to get raw data
>>> - Add PMU (Performance Monitoring Unit) for perf event
>>> - Add gps_alive power domain to remove power leakage when gps-alive isn't used
>>> - Remove duplicate dt data of interrput combiner controller
>>>
>>> exynos4412-trats.dts
>>> - Add ADC dt data with ntc thermistor child to read temperature
>>>
>>> Changes from v1:
>>> - Use clock macro name for Exynos4 instead of constant for ADC
>>> - Remove unnecessary description about patch content
>>> - Move gps-alive power domain's dt data from exynos4x12.dts to exynos4.dts
>>> - Move thermistor dt node outside of ADC dt node and modify node name of thermistor
>>>
>>> Chanwoo Choi (5):
>>>    ARM: dts: exynos4x12: Add ADC's dt data to read raw data
>>>    ARM: dts: exynos4x12: Add PMU dt data to support PMU(Perforamnce Monitoring Unit)
>>>    ARM: dts: exynos4x12: Add GPS_ALIVE power domain
>>>    ARM: dts: exynos: Move common dt data for interrupt combiner controller
>>>    ARM: dts: exynos4412-trats2: Add ADC/themistor dt data to get temperature of SoC/battery
>>>
>>>   arch/arm/boot/dts/exynos4.dtsi          |  5 +++++
>>>   arch/arm/boot/dts/exynos4212.dtsi       | 13 ++++---------
>>>   arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
>>>   arch/arm/boot/dts/exynos4412.dtsi       | 14 ++++----------
>>>   arch/arm/boot/dts/exynos4x12.dtsi       | 26 ++++++++++++++++++++++++++
>>>   5 files changed, 60 insertions(+), 19 deletions(-)
>>>
>>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>>
> 
> Please review or comment this patchset.
> 
> Best Regards,
> Chanwoo Choi
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

