Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaCLLn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:43:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64691 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaCLLn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:43:57 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-15-5320487be55a
Message-id: <5320487B.1090908@samsung.com>
Date: Wed, 12 Mar 2014 20:43:55 +0900
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsWyRsSkULfaQyHYoGG9ksX8I+dYLc69Wslo
	0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gsbl/mtVh6/SKTxYTpa1ksXh1sY7FYP+M1iwOP
	x5p5axg9Wpp72DxWLv/C5rF5Sb1H35ZVjB6fN8l5bJwbGsAexWWTkpqTWZZapG+XwJWx6IlM
	wW3+ir//mhkbGK/wdDFyckgImEhsXHOCEcIWk7hwbz1bFyMXh5DAUkaJpUv7WbsYOcCKPu3N
	hYgvYpR4/vAKK4TzilHizI9p7CDdvAJaEg/n3WADsVkEVCXm7JnCCmKzAcX3v4CIiwqESayc
	foUFol5Q4sfke2C2iICKxOVT0xlBhjILbGeSOHVkNliDsECCxIIZC5hBbCGBVIkP/9rAbE4B
	bYmlX3qZQGxmAR2J/a3T2CBseYnNa94ygwySEGjlkFh4cTc7xEUCEt8mH2KBeEdWYtMBZoiX
	JSUOrrjBMoFRbBaSm2YhGTsLydgFjMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQLj9vS/
	ZxN3MN4/YH2IMRlo5URmKdHkfGDc55XEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDo0qidFVCo1SuxbkIffVNWlf6flrUiC0x0ttwI/+nwdLEnCQP
	Q8XPm9nnTeq3qHy8s/gMe8apNt+mq+Zp0fvf7/jjLXR+pdsuixuT5G58ZbUQ06zPX3vl16dN
	q0KKPOUmr7D0MDZauqr+rOhnHt1f+XzV7EcerTQWmNn5/O/J3os7JzAo9hb/UGIpzkg01GIu
	Kk4EAJ4b23/xAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jAd1qD4Vgg2WfJC3mHznHanHu1UpG
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8XS6xeZLCZMX8ti8epgG4vF+hmvWRx4
	PNbMW8Po0dLcw+axcvkXNo/NS+o9+rasYvT4vEnOY+Pc0AD2qAZGm4zUxJTUIoXUvOT8lMy8
	dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygO5UUyhJzSoFCAYnFxUr6dpgmhIa4
	6VrANEbo+oYEwfUYGaCBhDWMGYueyBTc5q/4+6+ZsYHxCk8XIweHhICJxKe9uV2MnECmmMSF
	e+vZuhi5OIQEFjFKPH94hRXCecUocebHNHaQKl4BLYmH826wgdgsAqoSc/ZMYQWx2YDi+19A
	xEUFwiRWTr/CAlEvKPFj8j0wW0RAReLyqemMIEOZBbYzSZw6MhusQVggQWLBjAXMILaQQKrE
	h39tYDangLbE0i+9TCA2s4COxP7WaWwQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRNLUgu
	KE5KzzXSK07MLS7NS9dLzs/dxAhOCs+kdzCuarA4xCjAwajEw7tQUz5YiDWxrLgy9xCjBAez
	kgjvLluFYCHelMTKqtSi/Pii0pzU4kOMycAgmMgsJZqcD0xYeSXxhsYmZkaWRuaGFkbG5qQJ
	K4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXA2P/gBb9+iGPMpF9C81sCRSZ/ObDa4uH6ZzuW
	9b7Xb+5ZOvtfSMnd2/knrR+c7v162fvNFaF1V6ZN4cg0+CoZ3+q2VsbqHYeA3ILE049S597Z
	vlPiA2Nynqdk+U/GeTMfFQZYO/oUN//jvqAoVtytwfPn2+T3pwM9Lr/f9llh9/nLzDLXWPlX
	XVdiKc5INNRiLipOBADbdOdDTgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

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

Thanks for your review.

Best Regards,
Chanwoo Choi

