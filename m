Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaC0LMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:12:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35401 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaC0LMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:12:10 -0400
Message-ID: <5334078A.9010408@arm.com>
Date: Thu, 27 Mar 2014 11:12:10 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org> <533153BF.3070308@arm.com> <533163D4.6030205@linaro.org>
In-Reply-To: <533163D4.6030205@linaro.org>
X-OriginalArrivalTime: 27 Mar 2014 11:12:22.0950 (UTC) FILETIME=[6D552460:01CF49AD]
X-MC-Unique: 114032711120800701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On 25/03/14 11:09, Hanjun Guo wrote:
> Hi Sudeep,
> 
> On 2014-3-25 18:00, Sudeep Holla wrote:
>> Hi Hanjun,
>>
>> On 25/03/14 09:00, Hanjun Guo wrote:
>>> After commit 74397174989e5 (arm64: Fix duplicated Kconfig entries),
>>> I still get a duplicate Power management options section in linux-next
>>> git repo, may be due to some merge conflicts, anyway, fix that in this
>>> patch.
>>>
>> I reported this and Mark Brown posted the patch[1].
>> I assumed it is already pulled, but looks like that's not the case.
> [...]
>> [1] http://www.spinics.net/lists/arm-kernel/msg314472.html

[...]

> here is the link:
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm64/Kconfig
> 

Just had a look at the linux-next tree and looks like the original commit:
"cpufreq: enable ARM drivers on arm64" is pulled by both Catalin and Rafael
which has resulted in the fixup patch[1] not removing the duplicate entry
cleanly.

If not too late it better to ask either Rafael or Catalin to drop both patches
from their tree, instead of creating 4 patches in total to enable cpufreq :)

Regards,
Sudeep

