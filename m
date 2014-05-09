Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaEIHKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:10:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58434 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaEIHKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:10:32 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-b5-536c7f65726c
Message-id: <536C7F65.50503@samsung.com>
Date: Fri, 09 May 2014 16:10:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org, arnd@arndb.de,
        olof@lixom.net, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCHv4 7/7] ARM: dts: Add device tree sources for Exynos3250
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
 <1398388572-30239-8-git-send-email-cw00.choi@samsung.com>
 <535B0324.50705@gmail.com> <536C2A1C.6030807@samsung.com>
 <536C6175.5000302@gmail.com>
In-reply-to: <536C6175.5000302@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0iTYRTHe/be5nDxZmqP0gWksLQsc9YjXaXAl0Kygog+qHO9qbh0bDMq
	xEuZ1nCmm+QamVOcteWFpoRKS6dSmXljloamZVaaLgrNxJzktj74tW+/c/v/z4HDxTyshC83
	MVnOSpOFYj+Sh1d5CmQ72Azx6V2Z2s3IrnpOoceaWgKpalo4yNociErbuwl0e7qMQDM/sinU
	/c0AkGq0AEeDCzkEUurekKjr2jSFTJ/eEsjadI9Emp5nHDRk5SP78BKJ9AN9HPRqYIZEBcXV
	OLphbqdQx6ISoPG2nwTSqCdJVKuZwtFzTQVAxqZFgHLtZhKZG9Xg8Aam6n4VYLKv55HMnwUV
	YKz5Sg5jN05gTKP2PcUYHsySjMl4i2SG3z4lmbqKDKb/5TWCya83AmbGtDGKf463/zwrTrzE
	SncejOUlWHJeEZIij8u5/W+oTPCCrwBcLqQFcGTKRwHcltEb9o7UkgrA43rQegB783IxV0EA
	ZyfqKVehHEDdBwVwBVMA/n63SDm6+PRWmNM5z3EwTm+BraYs4GCSDoDNE4Okg73oM9BQ3I+7
	+tfAefWIkz1pfzhXdNvpgNENJJys7HIKraWPw8+6jn9uwwBmWkadSm70NlhraXQ6Y/R22Hzj
	DuniTbCuyoY5BiD9yA1qe75SrpVoOKduxV1Hb4Cmln+3+UDLw0G8AHhrVyylXSGrXSGrA5gR
	eLESkUQWFy8NDZIJL8pSk+ODRCkXTWD5oTqXvhQ2gNGWfa1AtGxZiPl6iVKWHy5ZHhMcsmc3
	ChWEhuzeG7bn/9J+6/jxY3GnPOh4oZxNYlkJK42RpopZWSvgcN18M8HZ2BTcszDCdqijXNhr
	f81PTPPZaAi3RGpPVvdtLvplkHd8jXavoZRJoogoVV7YCdtAUOQq691D4f0Nc0e62rGSo+ll
	+mFN9JPZ4jHzMV3lgXSvxLa0wCvzf9TV6W2a7Av6HqOadk+SXZ1ZPe7/MX9o/c0Ss/h7Fs+2
	ZEwtLdH74bIEYXAAJpUJ/wLoKPoLZgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsVy+t9jAd3U+pxggxOXJCz+TjrGbrFxxnpW
	i0nrDjBZXN6vbTH/yDlWi/43C1ktPn9oYbc492olo8Wk+xNYLG78amO16F1wlc3ibNMbdotN
	j6+xWlzeNYfNYsb5fUwWty/zWvy984/NYun1i0wWp65/ZrOYMH0ti0Xr3iPsFif/9DJaPDn8
	kdVixuSXbBbrZ7xmsTg2Ywmjxapdfxgt2v/uZbPYu3Myo4Osx5p5axg9Wpp72Dx+/5rE6HG5
	r5fJ4++qF8weO2fdZfdYufwLm8emVZ1sHneu7WHz2Lyk3uPKiSZWj74tqxg9Pm+SC+CNamC0
	yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAEGjZJCWWJO
	KVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx42DbKdaCKUIV7VeusjcwHuftYuTk
	kBAwkfjyYgs7hC0mceHeerYuRi4OIYFFjBILHnQxQjivGSW+3/wDVsUroCHRdvoHE4jNIqAq
	cWhTIyOIzSagJbH/xQ02EFtUIExi5fQrLBD1ghI/Jt8Ds0UE1CW+TelnBxnKLLCDTeLlsrNg
	g4QFvCWeLjgJte0Oo0TDwftgkzgFNCXWH9wJtplZQEdif+s0NghbXmLzmrfMExgFZiFZMgtJ
	2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCfAZ1I7GFc2WBxiFOBgVOLhfTEl
	O1iINbGsuDL3EKMEB7OSCK9Uek6wEG9KYmVValF+fFFpTmrxIcZkYBhMZJYSTc4HJue8knhD
	YxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamDcVeA/6ZfJDdb3PZfy
	Vsf9C9nXueqVW8w2iUl/vRxy79ncNNG+vySV48balQt+OX11/67nUeZr4jjjUODvT0b3LX6d
	vxb3cVvM6zNz7x/JW606v+bqZ82Spet6zG8u7D9+be2rVb43fj4yqHzVsyRNgF3p7IYfPJey
	V04PK+mTbcti/vrCf1JTohJLcUaioRZzUXEiAOXrCZPEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 05/09/2014 02:02 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 09.05.2014 03:06, Chanwoo Choi wrote:
>> On 04/26/2014 09:51 AM, Tomasz Figa wrote:
>>> On 25.04.2014 03:16, Chanwoo Choi wrote:
> 
> [snip]
> 
>>>> +    cpus {
>>>> +        #address-cells = <1>;
>>>> +        #size-cells = <0>;
>>>> +
>>>> +        cpu@0 {
>>>> +            device_type = "cpu";
>>>> +            compatible = "arm,cortex-a7";
>>>> +            reg = <0>;
>>>> +            clock-frequency = <1000000000>;
>>>> +        };
>>>
>>> Why only one CPU? I believe Exynos3250 is dual core.
>>
>> I'll add cpu1 information.
>>
>>> Also are physical IDs of the cores really 0 and 1? On Exynos4210 for example they are 0x900 and 0x901, while on Exynos4212 they are 0xa00 and 0xa01. Please check this.
>>
>> The 'reg' property means only hardware id(hwid) of CPU.
>> You can check it on arm_dt_init_cpu_maps() in arch/arm/kernel/devtree.c.h.
>> or Documentation/devicetree/bindings/arm/cpus.txt.
>>
> 
> Well, as described in Documentation/devicetree/bindings/arm/cpus.txt, on 32-bit ARM v7 or later CPUs the "reg" property should be equal to the lower 24-bits of MPIDR value of given CPU, which in addition to core ID includes also cluster ID, which can be non-zero, even on single cluster SoCs (like it is on Exynos4210 and 4x12).

I checked the lower 24-bit of MPIDR value for Exynos3250 in arm_dt_init_cpu_maps().
- the lower 24-bit of MPIDR for CPU0 is '0x0'.

> 
>>>> +    };
>>>> +
>>>> +    fixed-rate-clocks {
>>>> +        compatible = "simple-bus";
>>>> +        #address-cells = <1>;
>>>> +        #size-cells = <0>;
> 
> [snip]
> 
>>>> +    cmu: clock-controller@10030000 {
>>>> +        compatible = "samsung,exynos3250-cmu";
>>>> +        reg = <0x10030000 0x20000>;
>>>> +        #clock-cells = <1>;
>>>> +    };
>>>> +
>>>> +    rtc@10070000 {
>>>
>>> Please add label to the node, so it can be referenced from board dts files added later (using the method I explained above).
>>
>> OK, I'll add lable as following:
>>
>>     rtc_0: rtc@10070000 {
> 
> There is no need to suffix the RTC with _0, as there is just one RTC in the SoC. So in this case rtc: rtc@10070000 will be enough.

OK, I'll modify it without prefix('_0).

Best Regards,
Chanwoo Choi
