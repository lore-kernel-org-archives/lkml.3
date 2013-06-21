Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423304Ab3FUPTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:19:50 -0400
Received: from mout.gmx.net ([212.227.17.21]:59180 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423228Ab3FUPTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:19:48 -0400
X-Authenticated: #783749
X-Provags-ID: V01U2FsdGVkX19BiGZGmedB9D4XBNq98/1GnekQBYnmUp0jS3HHW6
	yuUO8o2Ntjk5jQ
Message-ID: <51C46F11.9020009@gmx.de>
Date: Fri, 21 Jun 2013 17:19:45 +0200
From: Dirk Schmidt <derschmied@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: Amd Phenom 2 X6 Cool&Quiet Issue.
References: <51C4600E.6030005@gmx.de> <20130621141906.GA526@x4> <51C4665A.8010802@gmx.de> <20130621151027.GB526@x4>
In-Reply-To: <20130621151027.GB526@x4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

It is a BIOS Bug of my Asrock K10N78D.

One has not only to enable Cool&Quiet but also AMD Turbo Core Technology 
or whatever.

I had AMD Turbo Core disabled so acpi_cpufreq would not load.

Solved ( for now ).

Sorry but I will not investigate further.

Thank you for your time and patience.

Bye.
Dirk Schmidt

Am 21.06.2013 17:10, schrieb Markus Trippelsdorf:
> On 2013.06.21 at 16:42 +0200, Dirk Schmidt wrote:
>> Hello.
>>
>> Am 21.06.2013 16:19, schrieb Markus Trippelsdorf:
>>> On 2013.06.21 at 16:15 +0200, Dirk Schmidt wrote:
>>>> Amd Phenom 2 X6 Cool&Quiet Issue.
>>>>
>>>> Problem:
>>>>
>>>> dmesg | grep power
>>>> [   10.622426] powernow-k8: This CPU is not supported anymore, using
>>>> acpi-cpufreq instead.
>>>>
>>>> modprobe acpi_cpufreq
>>>> ERROR: could not insert 'acpi_cpufreq': No such device
>>>
>>> Please post your kernel .config.
>>>
>>
>> config attached.
>>
>> #
>> # x86 CPU frequency scaling drivers
>> #
>> # CONFIG_X86_INTEL_PSTATE is not set
>> CONFIG_X86_PCC_CPUFREQ=m
>> CONFIG_X86_ACPI_CPUFREQ=m
>> CONFIG_X86_ACPI_CPUFREQ_CPB=y
>> CONFIG_X86_POWERNOW_K8=m
>> # CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
>> CONFIG_X86_SPEEDSTEP_CENTRINO=m
>> CONFIG_X86_P4_CLOCKMOD=m
>
> Does it work if you disable everything under "x86 CPU frequency scaling
> drivers" and build CONFIG_X86_ACPI_CPUFREQ directly into the kernel?
>
> #
> # x86 CPU frequency scaling drivers
> #
> # CONFIG_X86_INTEL_PSTATE is not set
> # CONFIG_X86_PCC_CPUFREQ is not set
> CONFIG_X86_ACPI_CPUFREQ=y
> # CONFIG_X86_ACPI_CPUFREQ_CPB is not set
> # CONFIG_X86_POWERNOW_K8 is not set
> # CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> # CONFIG_X86_P4_CLOCKMOD is not set
>
>


