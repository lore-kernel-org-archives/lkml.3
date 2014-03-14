Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaCNHOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 03:14:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29490 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaCNHOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 03:14:40 -0400
X-AuditID: cbfee690-b7f266d00000287c-c2-5322ac5ded0c
Message-id: <5322AC5D.9070200@samsung.com>
Date: Fri, 14 Mar 2014 16:14:37 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
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
In-reply-to: <20140313175308.GE25870@e106331-lin.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkRDd2jVKwwffjUhYdPb9ZLOYfOcdq
	ce7VSkaLs01v2C0Wti1hsbi8aw6bxefeI4wWM87vY7JYev0ik8XtxhVsFm9+nGWymDB9LYvF
	4xVv2S1eHWxjceDzWDNvDaPHyuVf2DwW73nJ5PFz+XZ2j74tqxg9jt/YzuTxeZOcx8a5oQEc
	UVw2Kak5mWWpRfp2CVwZ7/dKFHTLVhy428rawPhIvIuRk0NCwESi4ddKRghbTOLCvfVsXYxc
	HEICSxklZi9dyQRT9Ovub1aIxCJGiQUTpkE5rxglprfPYQWp4hXQkujf/4EZxGYRUJU4dPYn
	WDcbUHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosIqEv07PrCAjKUWeAuq8TiOWvAEsIC0RKX
	Jt+GumkXo8Tzjw1gGzgFnCXm370EVsQsoCOxv3UaG4QtL7F5zVtmkAYJgakcEp0f5rNDnCQg
	8W3yIaAGDqCErMSmA8wQv0lKHFxxg2UCo9gsJEfNQjJ2FpKxCxiZVzGKphYkFxQnpReZ6BUn
	5haX5qXrJefnbmIERvfpf88m7GC8d8D6EGMy0MqJzFKiyfnA5JBXEm9obGZkYWpiamxkbmlG
	mrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxVV7RuJ8pM/TbrITvrNMkjv/5u
	PuZ2oHuGSc7hsIfGm1ken88++CC86k+TsFhsbull/dPxs28fu+C9YaZoeYvVB3dBQZdLt7K6
	z8uphohJe8xs6fa8WLrxWe6Vz3694WHT/t96f+ZfDv/RlZstgkvsD+1M07qY8l51V5RJ1wr1
	aRKCGWxpW+2VWIozEg21mIuKEwFQebVBBAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAd3YNUrBBvseCVh09PxmsZh/5Byr
	xblXKxktzja9YbdY2LaExeLyrjlsFp97jzBazDi/j8li6fWLTBa3G1ewWbz5cZbJYsL0tSwW
	j1e8Zbd4dbCNxYHPY828NYweK5d/YfNYvOclk8fP5dvZPfq2rGL0OH5jO5PH501yHhvnhgZw
	RDUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHa6k
	UJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzHi/V6KgW7biwN1W1gbGR+Jd
	jJwcEgImEr/u/maFsMUkLtxbz9bFyMUhJLCIUWLBhGmsEM4rRonp7XPAqngFtCT6939gBrFZ
	BFQlDp39yQRiswHF97+4wQZiiwqESaycfoUFol5Q4sfke2C2iIC6RM+uLywgQ5kF7rJKLJ6z
	BiwhLBAtcWnybajVuxglnn9sANvAKeAsMf/uJbAiZgEdif2t09ggbHmJzWveMk9gFJiFZMks
	JGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcOp5J72Bc1WBxiFGAg1GJh3fG
	UcVgIdbEsuLK3EOMEhzMSiK8DPOUgoV4UxIrq1KL8uOLSnNSiw8xJgPDYCKzlGhyPjCt5ZXE
	GxqbmBlZGpkbWhgZm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD46oXeTqrNWRSDDNe
	nWoJ4Nf0/fRMJpBNbfHRQ0mxB6TzVbtmnRGwMXE50/PnxvU3PszcR3RXswZwOn+fcOD00kUJ
	K/Y8maI9Ky2IteWybdjfqWZf1i846Vv9zkeHT3eLXMRzf/9ZjDYn15Tz/00tb5jK4/+af1f/
	ruX8Ow9NYjhSWvwhTaRKX4mlOCPRUIu5qDgRAK/wk09hAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 03/14/2014 02:53 AM, Mark Rutland wrote:
> On Thu, Mar 13, 2014 at 08:17:29AM +0000, Chanwoo Choi wrote:
>> This patch add busfreq driver for Exynos4210/Exynos4x12 memory interface
>> and bus to support DVFS(Dynamic Voltage Frequency Scaling) according to PPMU
>> counters. PPMU (Performance Profiling Monitorings Units) of Exynos4 SoC provides
>> PPMU counters for DMC(Dynamic Memory Controller) to check memory bus utilization
>> and then busfreq driver adjusts dynamically the operating frequency/voltage
>> by using DEVFREQ Subsystem.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  .../devicetree/bindings/devfreq/exynos4_bus.txt    | 49 ++++++++++++++++++++++
>>  1 file changed, 49 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>
>> diff --git a/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>> new file mode 100644
>> index 0000000..2a83fcc
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>> @@ -0,0 +1,49 @@
>> +
>> +Exynos4210/4x12 busfreq driver
>> +-----------------------------
>> +
>> +Exynos4210/4x12 Soc busfreq driver with devfreq for Memory bus frequency/voltage
>> +scaling according to PPMU counters of memory controllers
>> +
>> +Required properties:
>> +- compatible	: should contain Exynos4 SoC type as follwoing:
>> +		  - "samsung,exynos4x12-busfreq" for Exynos4x12
>> +		  - "samsung,exynos4210-busfreq" for Exynos4210
> 
> Is there a device called "busfreq"? What device does this binding
> describe?

I'll add detailed description of busfreq as following:

"busfreq(bus frequendcy)" driver means that busfreq driver control dynamically
memory bus frequency/voltage by checking memory bus utilization to optimize
power-consumption. When checking memeory bus utilization, exynos4_busfreq driver
would use PPMU(Performance Profiling Monitoring Units).


> 
>> +- reg		: offset and length of the ppmudmc0/1
>> +		  - PPMU (Performance Profiling Monitoring Units)
> 
> You seem to require a particular order here. It would be good to be
> explicit about it.

OK, I'll modify it as following:
the offset and length of the PPMU_DMC0 / PPMU_DMC1
PPMU_DMC0/PPMU_DMC1 show memory buy utilization to exynos4_bus driver.

> 
>> +		  : It is to profile performance event of DMC(Dynamic Memory
>> +		  Controller) So, exynos4_bus.c can check memory bus utilization
>> +		  by using PPMU of Exynos4 SoC.
> 
> This is superfluous, and Linux-specific. The binding document shouldn't
> need to refer to drivers.

I'll remove this description.

> 
>> +- clocks	: clock number of ppmudmc0/1
>> +- clock-names	: clock name of ppmudmc0/1
> 
> Are these two clocks, or one clock with a slash in the name?
> 
> Please list each name separately.

I'll expalin clocks as following:
	"ppmudmc0", "ppmudmc1"

> 
>> +- vdd_int-supply: regulator for interface block of Exynos4
>> +
>> +Optional properties:
>> +- vdd_mif-supply: regulator for DMC block of Exynos4x12 if Exynos4x12 Soc
>> +- regs-name	: register name of ppmudmc0/1
> 
> This is completely nonstandard. Did you mean reg-names?

I'll remove it about 'regs-name'.

> 
> Please be explicit about the names you expect. Write them in full,
> quoted, and describe the relationship to the reg property.
> 
>> +
>> +All the required listed above must be defined under code busfreq with devfreq
> 
> I'm having some difficulty figuring out what exactly this is intended to
> mean.

I'll add detailed opeation method and role of exynos4_busfreq driver.

Thanks,
Chanwoo Choi
