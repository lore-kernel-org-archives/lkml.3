Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030326AbaDJLUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:20:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25901 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935056AbaDJLUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:20:13 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-8e-53467e69e2e8
Message-id: <53467E6A.6040105@samsung.com>
Date: Thu, 10 Apr 2014 20:20:10 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanho Park <chanho61.park@samsung.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, hyunhee.kim@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        yj44.cho@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 21/27] ARM: dts: exynos3250: Add PMU dt data
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397124377-16969-13-git-send-email-cw00.choi@samsung.com>
 <002701cf54a6$f6593720$e30ba560$@samsung.com>
In-reply-to: <002701cf54a6$f6593720$e30ba560$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWyRsSkSDezzi3Y4OR3aYvL+7UtPn9oYbeY
	dH8Ci0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jspgx+SWbxfoZr1ks9u6czOjA7bF5Sb1H
	35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZfxe/pi54BhvRUPvccYGxtncXYycHBICJhJ7Vh1h
	gbDFJC7cW8/WxcjFISSwlFHiys+pQA4HWNGKiZ4Q8UWMErPvLmKFcF4zSkw8f5kdpJtXQEvi
	x+sHYJNYBFQl7u/dxQhiswHF97+4wQZiiwqESaycfoUFol5Q4sfke2C2iIC2xOxHLWCbmQWm
	MEksnPaHFWSzsICDxIwdPhDLNjFK3Fo9C2wZp4CVxMqzy8GamQV0JPa3TmODsOUlNq95ywzS
	ICFwj11ixtJ1TBAXCUh8m3yIBeIdWYlNB5ghXpaUOLjiBssERrFZSG6ahWTsLCRjFzAyr2IU
	TS1ILihOSi8y1CtOzC0uzUvXS87P3cQIjMTT/5717mC8fcD6EGMy0MqJzFKiyfnASM4riTc0
	NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsab64O0J698
	eM+v+s2mW4buN39YPI0NEtjoO3XPQh6n/inuB4r/cn2aJ9V7hXlyT+ntl/aLJujzmczbMPfH
	3+xKUckvM2P7G6LW/TE5yln9IDOsdgl/0TJGWeEre0Pe58pbXf5UEnGp/q6G0/RdqiUTi5d1
	tay8tXweG6sp7+MPenvqPSSlY5qVWIozEg21mIuKEwGMJEzA2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd3MOrdgg5avQhaX92tbfP7Qwm4x
	6f4EFoveBVfZLM42vWG32PT4GqvF5V1z2CxmnN/HZDFj8ks2i/UzXrNY7N05mdGB22PzknqP
	vi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxe/lj5oJj
	vBUNvccZGxhnc3cxcnBICJhIrJjo2cXICWSKSVy4t56ti5GLQ0hgEaPE7LuLWCGc14wSE89f
	Zgep4hXQkvjx+gELiM0ioCpxf+8uRhCbDSi+/8UNNhBbVCBMYuX0KywQ9YISPybfA7NFBLQl
	Zj9qAdvALDCFSWLhtD+sIFcICzhIzNjhA7FsE6PErdWzwJZxClhJrDy7HKyZWUBHYn/rNDYI
	W15i85q3zBMYBWYh2TELSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH+TOp
	HYwrGywOMQpwMCrx8B5Y5hosxJpYVlyZe4hRgoNZSYQ3r9ItWIg3JbGyKrUoP76oNCe1+BBj
	MjAIJjJLiSbnA1NQXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUwBnZZTfn/1KG3YHOScKm4W3+yfmX1R2MX2awvb5UZglz5FL8/WjjzaGeEwKfXeU+D1tus
	Wjn79RlzU+4ze5xEb1jLnJU12qS5dLdeZe8mdoHNqvy7bPISdgU294o77Jn+q/16wlSBH2Gx
	dZKfjyy5JXn0yPJjX85Hz+Jct00lo7rlpHWtgsY2JZbijERDLeai4kQAccWrfTcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/10/2014 07:23 PM, Chanho Park wrote:
> Hi,
> 
>> -----Original Message-----
>> From: linux-arm-kernel [mailto:linux-arm-kernel-
>> bounces@lists.infradead.org] On Behalf Of Chanwoo Choi
>> Sent: Thursday, April 10, 2014 7:06 PM
>> To: kgene.kim@samsung.com; t.figa@samsung.com; linux-samsung-
>> soc@vger.kernel.org
>> Cc: hyunhee.kim@samsung.com; sw0312.kim@samsung.com; linux-
>> kernel@vger.kernel.org; yj44.cho@samsung.com; inki.dae@samsung.com;
>> cw00.choi@samsung.com; kyungmin.park@samsung.com; linux-arm-
>> kernel@lists.infradead.org
>> Subject: [PATCH 21/27] ARM: dts: exynos3250: Add PMU dt data
>>
>> From: Hyunhee Kim <hyunhee.kim@samsung.com>
>>
>> ARM CPU has its own PMU (Performance Monitoring Unit). This patch add
>> PMU dt
>> data to support PMU for CPU. Exynos3250 has four PMU interrupts.
>>
>> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos3250.dtsi | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos3250.dtsi
>> b/arch/arm/boot/dts/exynos3250.dtsi
>> index ceed761..2f0ca32 100644
>> --- a/arch/arm/boot/dts/exynos3250.dtsi
>> +++ b/arch/arm/boot/dts/exynos3250.dtsi
>> @@ -280,4 +280,9 @@
>>  		pinctrl-0 = <&i2c7_bus>;
>>  		status = "disabled";
>>  	};
>> +
>> +	pmu {
>> +		compatible = "arm,cortex-a7-pmu";
>> +		interrupts = <0 18 0>, <0 19 0>, <0 20 0>, <0 21 0>;
>> +	};
> 
> As I know, the exynos3250 has two CPU cores. Why does it have four pmu
> interrupts?
> IMO it is sufficient it has only two interrupts.

OK, I'll fix it using only two interrupt for dual-core.

Best Regards,
Chanwoo Choi
