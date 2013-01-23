Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3AWLIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:08:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41815 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab3AWLId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:08:33 -0500
Message-ID: <50FFC4E8.70509@ti.com>
Date: Wed, 23 Jan 2013 16:39:28 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex
 A9
References: <50FEC503.2080602@wwwdotorg.org><CAOesGMgtaCkiv285TU_vbAokN5M2MrANQ9piDcyXu5YMmbQq3A@mail.gmail.com><50FFA620.50008@ti.com> <20130123.125851.1450151123804323961.hdoyu@nvidia.com>
In-Reply-To: <20130123.125851.1450151123804323961.hdoyu@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2013 04:28 PM, Hiroshi Doyu wrote:
> Santosh Shilimkar <santosh.shilimkar@ti.com> wrote @ Wed, 23 Jan 2013 09:58:08 +0100:
>
>> On Tuesday 22 January 2013 10:34 PM, Olof Johansson wrote:
>>> On Tue, Jan 22, 2013 at 8:57 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> On 01/21/2013 11:07 PM, Santosh Shilimkar wrote:
>>>>> On Tuesday 22 January 2013 11:22 AM, Hiroshi Doyu wrote:
>>>>>> Skip scu_enable(scu_base) if CPU is not Cortex A9 with SCU.

[..]

>> Btw, I noticed the build error with patch 1/1. Since I wasn't using
>> the first interface in OMAP code, I just bypassed it for testing.
>> I might be missing some dependent patch which added
>> read_cpuid_part_number().
>
> The following one, which is in "next-20130123", is also necessary.
>
> commit 59530adc3f1b802c275f0197fc3ac72dc014267a
> Author: Christoffer Dall <c.dall@virtualopensystems.com>
> Date:   Tue Dec 18 04:06:37 2012 +0000
>
>      ARM: Define CPU part numbers and implementors
>
Thanks for the pointer Hiroshi.

Regards,
Santosh
