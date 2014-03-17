Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaCQFTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:19:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45187 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaCQFTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:19:43 -0400
X-AuditID: cbfee68e-b7f566d000002344-f5-532685dfafc5
Message-id: <532685E0.6040405@samsung.com>
Date: Mon, 17 Mar 2014 14:19:28 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "nm@ti.com" <nm@ti.com>,
        "b.zolnierkie@samsaung.com" <b.zolnierkie@samsaung.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCHv2 8/8] devfreq: exynos4: Add busfreq driver for
 exynos4210/exynos4x12
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <1394698649-20996-9-git-send-email-cw00.choi@samsung.com>
 <20140313175308.GE25870@e106331-lin.cambridge.arm.com>
 <5322AC5D.9070200@samsung.com>
 <20140314103552.GK25870@e106331-lin.cambridge.arm.com>
 <5322E04D.2060801@samsung.com> <53233DE7.2030902@samsung.com>
In-reply-to: <53233DE7.2030902@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkWPd+q1qwwYdL6hYdPb9ZLOYfOcdq
	ce7VSkaLs01v2C0Wti1hsbi8aw6bxefeI4wWM87vY7JYev0ik8XtxhVsFm9+nGWymDB9LYvF
	4xVv2S1eHWxjsVg/4zWLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4Mq4uK2RpWC2RsXjnzOYGhgXKnYxcnJICJhIfG2+xw5hi0lc
	uLeerYuRi0NIYCmjxKkTv4ASHGBFBxu8IeKLGCVu7nzNCOG8YpQ4ceQkC0g3r4CWxJF5zcwg
	NouAqkTX4lmsIDYbUHz/ixtsILaoQJjEyulXoOoFJX5MvgdmiwioSFw+NR1sKLNAC5vEztX3
	wU4SFoiWuDT5NlizkMAVJomVS7hBbE4BbYmPbYvAapgFdCT2t05jg7DlJTavecsM8c5CDokt
	K/QgDhKQ+Db5EAvEN7ISmw5AlUhKHFxxg2UCo9gsJCfNQjJ1FpKpCxiZVzGKphYkFxQnpRcZ
	6RUn5haX5qXrJefnbmIExvjpf8/6djDePGB9iDEZaOVEZinR5HxgisgriTc0NjOyMDUxNTYy
	tzQjTVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyCs6SZFnx6Zv0n8IrIp8mK
	Tycy7vZnF89eI/5HUlLTKDdZPfnBhM1p69pK2hufXM8PvRFxLXVS7fEN528/u3xhhZFw+h0p
	34yeBY3tqxi2H7401eLGFP4fIs6zu03maQQceayzMEDMTznwjPWeF3M3rWByEZ/QfVogtd6s
	WaN50pxH60yZtgkpsRRnJBpqMRcVJwIAHt5H2QcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jAd37rWrBBmu2yVp09PxmsZh/5Byr
	xblXKxktzja9YbdY2LaExeLyrjlsFp97jzBazDi/j8li6fWLTBa3G1ewWbz5cZbJYsL0tSwW
	j1e8Zbd4dbCNxWL9jNcsDvwea+atYfRYufwLm8fiPS+ZPH4u387u0bdlFaPH8RvbmTw+b5Lz
	2Dg3NIAjqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNct
	MwfoeiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxsVtjSwFszUqHv+c
	wdTAuFCxi5GDQ0LAROJgg3cXIyeQKSZx4d56ti5GLg4hgUWMEjd3vmaEcF4xSpw4cpIFpIpX
	QEviyLxmZhCbRUBVomvxLFYQmw0ovv/FDTYQW1QgTGLl9CtQ9YISPybfA7NFBFQkLp+aDjaU
	WaCFTWLn6vvsIAlhgWiJS5NvgzULCVxhkli5hBvE5hTQlvjYtgishllAR2J/6zQ2CFteYvOa
	t8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5Bn0jsYVzVY
	HGIU4GBU4uGdoKwWLMSaWFZcmXuIUYKDWUmEVy8WKMSbklhZlVqUH19UmpNafIgxGRgEE5ml
	RJPzgektryTe0NjEzMjSyNzQwsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYfa4n
	xrtXSfzlKjvds3JexullxiIbUsqnGzw4+6bm9bJF72/5pG1LeP4u0S3gkNDnh35RGy5uujXb
	eZGbsG7b1+OXCkzqDsedP5rlKrV5eXLOXv3rPcHu6qcXey+7/ewC7/urr706Tt6bXeD107R0
	EefaSIGDv3+0Z+x2tfAyZ9owWbg4XFnzuRJLcUaioRZzUXEiACpHdsVlAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/15/2014 02:35 AM, Tomasz Figa wrote:
> Hi Chanwoo, Mark,
> 
> On 14.03.2014 11:56, Chanwoo Choi wrote:
>> Hi Mark,
>>
>> On 03/14/2014 07:35 PM, Mark Rutland wrote:
>>> On Fri, Mar 14, 2014 at 07:14:37AM +0000, Chanwoo Choi wrote:
>>>> Hi Mark,
>>>>
>>>> On 03/14/2014 02:53 AM, Mark Rutland wrote:
>>>>> On Thu, Mar 13, 2014 at 08:17:29AM +0000, Chanwoo Choi wrote:
>>>>>> This patch add busfreq driver for Exynos4210/Exynos4x12 memory interface
>>>>>> and bus to support DVFS(Dynamic Voltage Frequency Scaling) according to PPMU
>>>>>> counters. PPMU (Performance Profiling Monitorings Units) of Exynos4 SoC provides
>>>>>> PPMU counters for DMC(Dynamic Memory Controller) to check memory bus utilization
>>>>>> and then busfreq driver adjusts dynamically the operating frequency/voltage
>>>>>> by using DEVFREQ Subsystem.
>>>>>>
>>>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>>> ---
>>>>>>   .../devicetree/bindings/devfreq/exynos4_bus.txt    | 49 ++++++++++++++++++++++
>>>>>>   1 file changed, 49 insertions(+)
>>>>>>   create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>>>>> new file mode 100644
>>>>>> index 0000000..2a83fcc
>>>>>> --- /dev/null
>>>>>> +++ b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>>>>> @@ -0,0 +1,49 @@
>>>>>> +
>>>>>> +Exynos4210/4x12 busfreq driver
>>>>>> +-----------------------------
>>>>>> +
>>>>>> +Exynos4210/4x12 Soc busfreq driver with devfreq for Memory bus frequency/voltage
>>>>>> +scaling according to PPMU counters of memory controllers
>>>>>> +
>>>>>> +Required properties:
>>>>>> +- compatible    : should contain Exynos4 SoC type as follwoing:
>>>>>> +          - "samsung,exynos4x12-busfreq" for Exynos4x12
>>>>>> +          - "samsung,exynos4210-busfreq" for Exynos4210
>>>>>
>>>>> Is there a device called "busfreq"? What device does this binding
>>>>> describe?
>>>>
>>>> I'll add detailed description of busfreq as following:
>>>>
>>>> "busfreq(bus frequendcy)" driver means that busfreq driver control dynamically
>>>> memory bus frequency/voltage by checking memory bus utilization to optimize
>>>> power-consumption. When checking memeory bus utilization, exynos4_busfreq driver
>>>> would use PPMU(Performance Profiling Monitoring Units).
>>>
>>> This still sounds like a description of the _driver_, not the _device_.
>>> The binding should describe the hardware, now the high level abstraction
>>> that software is going to build atop of it.
>>>
>>> It sounds like this is a binding for the DMC PPMU?
>>>
>>> Is the PPMU a component of the DMC, or is it bolted on the side?
>>
>> PPMU(Performance Profiling Monitoring Unit) is to profile performance event of
>> various IP on Exynos4. Each PPMU provide perforamnce event for each IP.
>> We can check various PPMU as following:
>>
>> PPMU_3D
>> PPMU_ACP
>> PPMU_CAMIF
>> PPMU_CPU
>> PPMU_DMC0
>> PPMU_DMC1
>> PPMU_FSYS
>> PPMU_IMAGE
>> PPMU_LCD0
>> PPMU_LCD1
>> PPMU_MFC_L
>> PPMU_MFC_R
>> PPMU_TV
>> PPMU_LEFT_BUS
>> PPMU_RIGHT_BUS
>>
>> DMC (Dynamic Memory Controller) control the operation of DRAM in Exynos4 SoC.
>> If we need to get memory bust utilization of DMC, we can get memory bus utilization
>> from PPMU_DMC0/PPMU_DMC1.
>>
>> So, Exynos4's busfreq used two(PPMU_DMC0/PPMU_DMC1) among upper various PPMU list.
> 
> Well, PPMUs and DMCs are separate hardware blocks found inside Exynos SoCs. Busfreq/devfreq is just a Linux-specific abstraction responsible for collecting data using PPMUs and controlling frequencies and voltages of appropriate power planes, vdd_int responsible for powering DMC0 and DMC1 blocks in this case.
> 

I knew already.

> I'm afraid that the binding you're proposing is unfortunately incorrect, because it represents the software abstraction, not the real hardware.

What is exactly incorrect part of this patch?

> 
> Instead, this should be separated into several independent bindings:
> 
>  - PPMU bindings to list all the PPMU instances present in the SoC and resources they need,
> 
>  - power plane bindings, which define a power plane in which multiple IP blocks might reside, can be monitored by one or more PPMU units and frequency and voltage of which can be configured according to determined performance level. Needed resources will be clocks and regulators to scale and probably also operating points.
> 
> Then, exynos-busfreq driver should bind to such power planes, parse necessary data from DT (list of PPMUs and IP blocks, clocks, regulators and operating points) and register a devfreq entity.

What is 'power plane'? I don't know 'power plane'.
If you suggest 'power plane' concept and then merge this concept to mainline,
After merged 'power plane' concept, I will apply 'power plane' concept to Exynos4's busfreq driver.

I prefer to handle 'power plane' concept on other patchset for Exynos4's busfreq driver.

Best Regards,
Chanwoo Choi

