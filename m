Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaD2HrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:47:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35092 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaD2HrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:47:07 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-e3-535f58f3ed55
Message-id: <535F5D2D.4000406@samsung.com>
Date: Tue, 29 Apr 2014 17:05:01 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lee Jones <lee.jones@linaro.org>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, Samuel Ortiz <sameo@linux.intel.com>,
        b.zolnierkie@samsung.com, Sangbeom Kim <sbkim73@samsung.com>,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESUBMIT RFC PATCH v2 3/3] drivers: mfd: Add support for Exynos
 PMU driver
References: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
 <1398687607-4554-4-git-send-email-pankaj.dubey@samsung.com>
 <20140428122646.GF21279@lee--X1> <20140428173743.GA14853@arm.com>
In-reply-to: <20140428173743.GA14853@arm.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zfd3PEfHBBjf/a1tsnLGe1eL9sh5G
	i2WT7rJZ9C64ymZx/+tRRotNj6+xWlzeNYfNYsb5fUwWty/zWpzuZrW4uOILk8X6Ga9ZLG4+
	285ksaNlNYsDn8eaeWsYPVqae9g87lzbw+Yx72Sgx+Yl9R59W1YxenzeJBfAHsVlk5Kak1mW
	WqRvl8CVcfXcSdaCA8IV1/YfZm9g7ODvYuTkkBAwkfj29Sg7hC0mceHeerYuRi4OIYFljBLP
	Ws8ywRR1rFnPCpGYziixvKWBEcJ5zSixZ/8ZRpAqXgEtid13NoGNYhFQldh6r4kNxGYT0JV4
	8n4uM4gtKhAmsWl6HytEvaDEj8n3WEBsEaCaC21TWECGMgu0M0tsn/EOrEhYIEpi69UWqNUn
	GSWOzP4DdhMnUEfDjYtg25gFrCVWTtrGCGHLS2xe85YZpEFCoJdDYu+iHYwQJwlIfJt8CGgF
	B1BCVmLTAWaI3yQlDq64wTKBUWwWkqNmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9IoTc4tL89L1
	kvNzNzFC4rlvB+PNA9aHGJOBVk5klhJNzgemg7ySeENjMyMLUxNTYyNzSzPShJXEeRc9TAoS
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJj1mEvkxHrfKXOUCh9eKItjS0vKmFS4wk422TdI
	6fFfe201jdq/3HPCdOY6L2aYetMwsyX2ms3cj5/ucZoqPtbaMH/21jWWi4SDXbjCBVe792n0
	Pj+TE9+v7jhlR/nOjQX8QipHbezP1gebvKhX7Os6fsp/nrXNvagHdZ6HebvtO42Pr979T4ml
	OCPRUIu5qDgRACu+0RP9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQd3PEfHBBhdnq1lsnLGe1eL9sh5G
	i2WT7rJZ9C64ymZx/+tRRotNj6+xWlzeNYfNYsb5fUwWty/zWpzuZrW4uOILk8X6Ga9ZLG4+
	285ksaNlNYsDn8eaeWsYPVqae9g87lzbw+Yx72Sgx+Yl9R59W1YxenzeJBfAHtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLCSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePquZOsBQeEK67tP8zewNjB38XIySEhYCLR
	sWY9K4QtJnHh3nq2LkYuDiGB6YwSy1saGCGc14wSe/afYQSp4hXQkth9ZxM7iM0ioCqx9V4T
	G4jNJqAr8eT9XGYQW1QgTGLT9D5WiHpBiR+T77GA2CJANRfaprCADGUWaGeW2D7jHViRsECU
	xNarLawQ204yShyZ/YcJJMEJ1NFw4yLYNmYBa4mVk7YxQtjyEpvXvGWewCgwC8mSWUjKZiEp
	W8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOFk8k9rBuLLB4hCjAAejEg+vQVRcsBBr
	YllxZe4hRgkOZiUR3nyr+GAh3pTEyqrUovz4otKc1OJDjMnAMJjILCWanA9MZHkl8YbGJmZG
	lkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwMho+vn2uXXuW+eW+K85fkfp
	Z1sBy+6Xu5stYsz4sv8pbdIPSlOInLItdnLfRFaPue8+5T7zWXz8rl/mruQvfdtL01abuTho
	uNRbXCy0eex/2PTOiT+zmKy4czL8em8Gs8X4nX/zcq2m9tR/gtWZM/eukuVjEZ0q8slnJVvh
	Bsl7GVG1WgeLc5RYijMSDbWYi4oTAW4DdOxaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 02:37 AM, Catalin Marinas wrote:
> On Mon, Apr 28, 2014 at 01:26:46PM +0100, Lee Jones wrote:
>>> This patch moves Exynos PMU driver implementation from
>>> "arm/mach-exynos" to "drivers/mfd".
>>> This driver is mainly used for setting misc bits of register from PMU IP
>>> of Exynos SoC which will be required to configure before Suspend/Resume.
>>> Currently all these settings are done in "arch/arm/mach-exynos/pmu.c" but
>>> moving ahead for ARM64 based SoC support, there is a need of DT based
>>> implementation of PMU driver.
>>> This driver uses already existing DT binding information.
>>>
>>> CC: Sangbeom Kim <sbkim73@samsung.com>
>>> CC: Samuel Ortiz <sameo@linux.intel.com>
>>> CC: Lee Jones <lee.jones@linaro.org>
>>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>>> ---
>>>   arch/arm/mach-exynos/Kconfig                           |    2 ++
>>>   arch/arm/mach-exynos/Makefile                          |    2 --
>>>   drivers/mfd/Kconfig                                    |    9 +++++++++
>>>   drivers/mfd/Makefile                                   |    1 +
>>>   arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c |    0
>>>   5 files changed, 12 insertions(+), 2 deletions(-)
>>>   rename arch/arm/mach-exynos/pmu.c => drivers/mfd/exynos-pmu.c (100%)
>> So I just took a look at the code as zero changes looks suspicious to
>> me. The driver can not simply be copied and pasted into the MFD
>> subsystem in its current state.
>>
>> The fundamental question is; is this chip actually an MFD? What does
>> it do besides Power Management?
> I looked at the code briefly as well and I don't think it matches the
> mfd idea. Maybe it could be merged together with
> arch/arm/mach-exynos/pm.c and moved to drivers/power/ or a more
> appropriate directory for platform_suspend_ops.

Well I was also not quite sure about if "drivers/mfd" is proper place
for Exynos PMU, so I posted this patch as RFC.

If it does not seems matching with "drivers/mfd" idea, will it be suitable
for "drivers/power/" or should I go for something like "drivers/soc/samsung"?

Regarding your second point about merging this code with "mach-exynos/pm.c"
We have plan for this but, I would like to get it done via a separate patch 
series
as "mach-exynos/pm.c" has a lot of dependencies and requires significant
modifications. So this work can be treated as a first step towards that 
direction.

-- 
Best Regards,
Pankaj Dubey

