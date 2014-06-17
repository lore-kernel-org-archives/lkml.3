Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813AbaFQM0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:26:37 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54389 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbaFQM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:26:35 -0400
Message-ID: <53A03391.8040207@linux.vnet.ibm.com>
Date: Tue, 17 Jun 2014 17:54:49 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@samsung.com>
CC: linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org, akpm@linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlz?= =?UTF-8?B?YmVja2Vy?= 
	<fweisbec@gmail.com>
Subject: Re: Boot warnings on exynos5420 based boards
References: <CAK5sBcEJOJDtt_7ow=q=hiN8-JRHzOUg6t=T3hTNOwzKq5dodw@mail.gmail.com> <53A007F7.6020103@linux.vnet.ibm.com> <CAK5sBcECq5sN9CnUhWLPoYnFnPz64JM_6CVRBwjz8Q2=X5_t=A@mail.gmail.com> <53A01039.2020302@linux.vnet.ibm.com> <CAK5sBcH6Yw0rdfUgTPi2OhqZ5pNeD39_NUguT4NFR4hrK2uZgA@mail.gmail.com>
In-Reply-To: <CAK5sBcH6Yw0rdfUgTPi2OhqZ5pNeD39_NUguT4NFR4hrK2uZgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061712-5816-0000-0000-00000EAFC2B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 05:25 PM, Sachin Kamat wrote:
> Hi Srivatsa,
> 
> On Tue, Jun 17, 2014 at 3:24 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 06/17/2014 03:03 PM, Sachin Kamat wrote:
>>
>>>> Below is an updated patch, please let me know how it goes. (You'll have to
>>>> revert c47a9d7cca first, and then 56e692182, before trying this patch).
>>>
>>> I am unable to apply your below patch on top of the above 2 reverts.
>>> Applying: CPU hotplug, smp: Execute any pending IPI callbacks before CPU offline
>>> fatal: corrupt patch at line 106
>>> Patch failed at 0001 CPU hotplug, smp: Execute any pending IPI
>>> callbacks before CPU offline
>>>
>>> Even with 'patch' I get the below failures:
>>> patching file kernel/smp.c
>>> Hunk #2 FAILED at 53.
>>> Hunk #3 FAILED at 179.
>>> 2 out of 3 hunks FAILED -- saving rejects to file kernel/smp.c.rej
>>>
>>
>> Hmm, weird. My mailer must have screwed it up.
>>
>> Let's try again:
>>
>> [In case this also doesn't work for you, please use this git tree in which
>>  I have reverted the 2 old commits and added this updated patch.
>>
>>  git://github.com/srivatsabhat/linux.git ipi-offline-fix-v3
>> ]
> 
> Unfortunately the attached patch did not apply either. Nevertheless, I
> applied the
> patch from your above mentioned tree. With that patch I do not see the warnings
> that I mentioned in my first mail. Thanks for fixing it.
> 

Sure, thanks for reporting the bug and testing the updated patch!
By the way, I think there is some problem in the workflow that you use to
copy-paste/apply the patch. I tried applying both patches (that I sent in
2 different mails) and both applied properly without any problems.

Regards,
Srivatsa S. Bhat

