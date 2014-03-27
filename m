Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaC0Meu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:34:50 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59240 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaC0Met (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:34:49 -0400
Message-ID: <53341ADF.2050904@linaro.org>
Date: Thu, 27 Mar 2014 20:34:39 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org> <533153BF.3070308@arm.com> <533163D4.6030205@linaro.org> <5334078A.9010408@arm.com>
In-Reply-To: <5334078A.9010408@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-3-27 19:12, Sudeep Holla wrote:
> Hi Hanjun,
> 
> On 25/03/14 11:09, Hanjun Guo wrote:
>> Hi Sudeep,
>>
>> On 2014-3-25 18:00, Sudeep Holla wrote:
>>> Hi Hanjun,
>>>
>>> On 25/03/14 09:00, Hanjun Guo wrote:
>>>> After commit 74397174989e5 (arm64: Fix duplicated Kconfig entries),
>>>> I still get a duplicate Power management options section in linux-next
>>>> git repo, may be due to some merge conflicts, anyway, fix that in this
>>>> patch.
>>>>
>>> I reported this and Mark Brown posted the patch[1].
>>> I assumed it is already pulled, but looks like that's not the case.
>> [...]
>>> [1] http://www.spinics.net/lists/arm-kernel/msg314472.html
> 
> [...]
> 
>> here is the link:
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm64/Kconfig
>>
> 
> Just had a look at the linux-next tree and looks like the original commit:
> "cpufreq: enable ARM drivers on arm64" is pulled by both Catalin and Rafael
> which has resulted in the fixup patch[1] not removing the duplicate entry
> cleanly.
> 
> If not too late it better to ask either Rafael or Catalin to drop both patches
> from their tree, instead of creating 4 patches in total to enable cpufreq :)

Rafael is on vacation now.

Catalin, could you please handle this?

Thanks
Hanjun

