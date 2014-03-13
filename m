Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaCMB5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:57:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60673 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaCMB5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:57:19 -0400
X-AuditID: cbfee68f-b7f156d00000276c-bb-532110716e63
Message-id: <53211071.4040408@samsung.com>
Date: Thu, 13 Mar 2014 10:57:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk
Subject: Re: [PATCHv2 0/5] ARM: dts: exynos: Add missing dt data to bring
 kernel of Exynos4x12
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
 <53204328.7070607@samsung.com>
In-reply-to: <53204328.7070607@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsWyRsSkWLdQQDHYYMksJYv5R86xWpx7tZLR
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma7H0+kUmiwnT17JYvDrYxmKxfsZrFgce
	jzXz1jB6tDT3sHmsXP6FzWPzknqPvi2rGD0+b5Lz2Dg3NIA9issmJTUnsyy1SN8ugSujdfFa
	xoL3/BWXP1s3MD7h6WLk5JAQMJH4teASE4QtJnHh3nq2LkYuDiGBpYwSD29uZIYpWr/2MVRi
	OqNE19nJzBDOK0aJnu1bGUGqeAW0JPY2L2IDsVkEVCW2/P8D1s0GFN//4gZYXFQgTGLl9Css
	EPWCEj8m3wOzRQRUJC6fms4IMpRZYDuTxKkjs8EahAUSJBbMWAA2SEggVeLDvzYwm1NAW2Lp
	l16wu5kFdCT2t05jg7DlJTaveQt2nYTAT3aJI2tvsUNcJCDxbfIhoG0cQAlZiU0HoF6TlDi4
	4gbLBEaxWUhumoVk7CwkYxcwMq9iFE0tSC4oTkovMtYrTswtLs1L10vOz93ECIzc0/+e9e9g
	vHvA+hBjMtDKicxSosn5wMjPK4k3NDYzsjA1MTU2Mrc0I01YSZz3/sOkICGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2MB6Z+eZk7bYGQveFqv6/SqmfFvz+KUDHwejSnIG9eSeZTmaqAZ/4r
	/2xrmN+bordg+5Zb/fNc9096toOt9bHWu5kVU+TkLC9O9z/mzWdz6e3NFfIxBruWdEXX64kt
	O/XOMvlUiw1TlGkT26TFimkGbzfX7lvgWqgptPuxO/8J4RteL+ztwnctV2Ipzkg01GIuKk4E
	AJzGHoryAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jQd1CAcVgg23TJC3mHznHanHu1UpG
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8XS6xeZLCZMX8ti8epgG4vF+hmvWRx4
	PNbMW8Po0dLcw+axcvkXNo/NS+o9+rasYvT4vEnOY+Pc0AD2qAZGm4zUxJTUIoXUvOT8lMy8
	dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygO5UUyhJzSoFCAYnFxUr6dpgmhIa4
	6VrANEbo+oYEwfUYGaCBhDWMGa2L1zIWvOevuPzZuoHxCU8XIyeHhICJxPq1j9kgbDGJC/fW
	A9lcHEIC0xklus5OZoZwXjFK9GzfyghSxSugJbG3eRFYB4uAqsSW/3+YQWw2oPj+FzfA4qIC
	YRIrp19hgagXlPgx+R6YLSKgInH51HRGkKHMAtuZJE4dmQ3WICyQILFgxgKwQUICqRIf/rWB
	2ZwC2hJLv/QygdjMAjoS+1unsUHY8hKb17xlnsAoMAvJjllIymYhKVvAyLyKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzgtPJPewbiqweIQowAHoxIP74rlCsFCrIllxZW5hxglOJiVRHi7
	1gCFeFMSK6tSi/Lji0pzUosPMSYDg2Ais5Rocj4wZeWVxBsam5gZWRqZG1oYGZuTJqwkznuw
	1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6MfC/vXhSG/FDbeuv8kz0QhXbM7+/kZZSXxEP7/VRd2
	JEqpGvZFqfDPXnLvgsgVJXuHC1M2tNROkfb1XeS+lsGy85ji8oJ5mZw7nhnfetG8YtJaZesD
	DF1uC0VL798svJy12TGvL0Gx8NB5q9J5q9KLPTUjXH663zvGz6Ze3baQnefp5o7QY0osxRmJ
	hlrMRcWJAG1gDwNPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

On 03/12/2014 08:21 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 12.03.2014 07:19, Chanwoo Choi wrote:
>> This patch add missing dt data of Exynos4x12 to bring up kernel feature and
>> code clean. This patchset is based on 'v3.15-next/dt-clk-exynos' branch.
>> - git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
>>
>> exynos4x12/exynos4412/exynos4212.dtsi
>> - Add ADC (Analog and Digital Converter) to get raw data
>> - Add PMU (Performance Monitoring Unit) for perf event
>> - Add gps_alive power domain to remove power leakage when gps-alive isn't used
>> - Remove duplicate dt data of interrput combiner controller
>>
>> exynos4412-trats.dts
>> - Add ADC dt data with ntc thermistor child to read temperature
>>
>> Changes from v1:
>> - Use clock macro name for Exynos4 instead of constant for ADC
>> - Remove unnecessary description about patch content
>> - Move gps-alive power domain's dt data from exynos4x12.dts to exynos4.dts
>> - Move thermistor dt node outside of ADC dt node and modify node name of thermistor
>>
>> Chanwoo Choi (5):
>>    ARM: dts: exynos4x12: Add ADC's dt data to read raw data
>>    ARM: dts: exynos4x12: Add PMU dt data to support PMU(Perforamnce Monitoring Unit)
>>    ARM: dts: exynos4x12: Add GPS_ALIVE power domain
>>    ARM: dts: exynos: Move common dt data for interrupt combiner controller
>>    ARM: dts: exynos4412-trats2: Add ADC/themistor dt data to get temperature of SoC/battery
>>
>>   arch/arm/boot/dts/exynos4.dtsi          |  5 +++++
>>   arch/arm/boot/dts/exynos4212.dtsi       | 13 ++++---------
>>   arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
>>   arch/arm/boot/dts/exynos4412.dtsi       | 14 ++++----------
>>   arch/arm/boot/dts/exynos4x12.dtsi       | 26 ++++++++++++++++++++++++++
>>   5 files changed, 60 insertions(+), 19 deletions(-)
>>
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 

Please review or comment this patchset.

Best Regards,
Chanwoo Choi


