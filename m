Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaEIIBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:01:48 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53663 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaEIIBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:01:46 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-47-536c8b669948
Message-id: <536C8B63.3000400@samsung.com>
Date: Fri, 09 May 2014 10:01:39 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
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
 <536C6175.5000302@gmail.com> <536C7F65.50503@samsung.com>
In-reply-to: <536C7F65.50503@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0iTYRTHed5377sLrl6d1pNkxqggK1O68BBd/CD2ggSJX0SDWrqmsM2x
	paUELZ3abV420TXCDBVxmtK00uEy1DST1Jw5yaWpiXdSt0yXk9z2xW+/c87/nN+Xw8L9xhmB
	rBTpbaFcKhDzSQ6jd6vbcuLWE3Fs2NZDiFyaLiZ6rWsgkKb+A4YsbceQ1TFDoBedfQQqWHxJ
	IPuyion65msA0owXMtCIM5dA6vJvJPqStchExqlhAllMz0mk63+PoVELF7lsWySqsn7F0Ger
	nUSFpa8YKMfcyUQ9m2qAfnWsEEinnSNRl64SIINpE6A8l5lE5hYtiAii68rqAK3KfkrS/5wa
	QFvy1RjtMszidIv+B5OuqXaQtNHwiKRtw60k3Vh5nx76lEXQ+U0GQNuNB65y4znnk4TilHSh
	/OTFG5xks34Slw363F3YqMeVYJT9GLBZkDoNB99Ok17eAwfGGraZw/KjqgBUrT7DvIUdwKKR
	XOBOcakQOFPhwtzMoA7D5UYN4WaSOgLtyknPpd3bmbosK8PNAVQcHHvQQXh3feG6dszT96eu
	QPV6pceGU5UkNBbk4e4Bj4qG0+U9wGveALD2u9ZjZlNHYdGaymPGqeOwLaeE9HIwbKxbwguB
	r36HRL8jpt8RKwe4AQQI0xJlipsiSXioQiBRpElFoYmpEiPwPoWjGVR0nWsHFAvwfbizCcmx
	foQgXZEhaQeQhfP9uYEicawfN0mQkSmUp16Xp4mFinaAsdiBSqDq/BlufmeKmpsqDnMF2Uz2
	9d7IpYSF4tbVmDVHywVbVDrvrOzvvQjBhDwmLiM7eogX1Lz3jmaXsrSaZeJGHiqRTtfK/sy3
	ZcrYPisB+x2imsvzUc5go/6389SllO6ya8G6j5ymatu8zo7tUzaYz/RPDBQcTNbx8uIne12j
	b/gMRbIgPASXKwT/AWxIp+fyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09.05.2014 09:10, Chanwoo Choi wrote:
> Hi Tomasz,
> 
> On 05/09/2014 02:02 PM, Tomasz Figa wrote:
>> Hi Chanwoo,
>>
>> On 09.05.2014 03:06, Chanwoo Choi wrote:
>>> On 04/26/2014 09:51 AM, Tomasz Figa wrote:
>>>> On 25.04.2014 03:16, Chanwoo Choi wrote:
>>
>> [snip]
>>
>>>>> +    cpus {
>>>>> +        #address-cells = <1>;
>>>>> +        #size-cells = <0>;
>>>>> +
>>>>> +        cpu@0 {
>>>>> +            device_type = "cpu";
>>>>> +            compatible = "arm,cortex-a7";
>>>>> +            reg = <0>;
>>>>> +            clock-frequency = <1000000000>;
>>>>> +        };
>>>>
>>>> Why only one CPU? I believe Exynos3250 is dual core.
>>>
>>> I'll add cpu1 information.
>>>
>>>> Also are physical IDs of the cores really 0 and 1? On Exynos4210 for example they are 0x900 and 0x901, while on Exynos4212 they are 0xa00 and 0xa01. Please check this.
>>>
>>> The 'reg' property means only hardware id(hwid) of CPU.
>>> You can check it on arm_dt_init_cpu_maps() in arch/arm/kernel/devtree.c.h.
>>> or Documentation/devicetree/bindings/arm/cpus.txt.
>>>
>>
>> Well, as described in Documentation/devicetree/bindings/arm/cpus.txt, on 32-bit ARM v7 or later CPUs the "reg" property should be equal to the lower 24-bits of MPIDR value of given CPU, which in addition to core ID includes also cluster ID, which can be non-zero, even on single cluster SoCs (like it is on Exynos4210 and 4x12).
> 
> I checked the lower 24-bit of MPIDR value for Exynos3250 in arm_dt_init_cpu_maps().
> - the lower 24-bit of MPIDR for CPU0 is '0x0'.

Fair enough. Thanks.

Best regards,
Tomasz
