Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaIYI0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:26:24 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37175 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIYI0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:26:14 -0400
Message-ID: <5423D19B.1040203@samsung.com>
Date: Thu, 25 Sep 2014 17:26:03 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Kukjin Kim <kgene@kernel.org>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "'Thomas Abraham'" <ta.omasab@gmail.com>, daniel.lezcano@linaro.org
Subject: Re: [PATCH v3] ARM: dts: add CPU nodes for Exynos4 SoCs
References: <5230569.XLlNbB5NvF@amdc1032> <018e01cfd885$770dd940$65298bc0$@kernel.org> <20140925081704.GA20841@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140925081704.GA20841@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/14 17:17, Lorenzo Pieralisi wrote:
> [CC'ed Daniel to make him aware this patch goes through your tree]
>
Thanks and just note the branch  which is including this change actually 
v4 is just rebased not v3 will be sent out to arm-soc last tonight or 
tomorrow.

- Kukjin

> On Thu, Sep 25, 2014 at 06:56:33AM +0100, Kukjin Kim wrote:
>> Bartlomiej Zolnierkiewicz wrote:
>>>
>>> Recent patch by Tomasz Figa ("irqchip: gic: Fix core ID calculation
>>> when topology is read from DT") fixed GIC driver to filter cluster ID
>>> from values returned by cpu_logical_map() for SoCs having registers
>>> mapped without per-CPU banking making it is possible to add CPU nodes
>>> for Exynos4 SoCs.  In case of Exynos SoCs these CPU nodes are also
>>> required by future changes adding initialization of cpuidle states in
>>> Exynos cpuidle driver through DT.
>>>
>>> Tested on Origen board (Exynos4210 SoC) and Trats2 (Exynos4412 SoC).
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
>>> ---
>>> Based on for-next branch of linux-samsung.git tree.
>>>
>>> v3:
>>> - refreshed on top of Kukjin's tree
>>>
>>> v2:
>>> - match the unit-address with the reg
>>>
>>>   arch/arm/boot/dts/exynos4210.dtsi |   17 +++++++++++++++++
>>>   arch/arm/boot/dts/exynos4212.dtsi |   17 +++++++++++++++++
>>>   arch/arm/boot/dts/exynos4412.dtsi |   29 +++++++++++++++++++++++++++++
>>>   3 files changed, 63 insertions(+)
>>
>> Thanks for re-spin and looks good to me.
>>
>> Applied.
>
> That's great, now my Exynos CPUidle DT patch should be rebased on top
> of this patch so that thanks to the testing carried out by Bart it can be
> merged too.
>
> Lorenzo
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
