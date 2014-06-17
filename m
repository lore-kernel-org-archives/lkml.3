Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaFQLzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:55:04 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36497 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaFQLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:55:01 -0400
MIME-Version: 1.0
In-Reply-To: <53A01039.2020302@linux.vnet.ibm.com>
References: <CAK5sBcEJOJDtt_7ow=q=hiN8-JRHzOUg6t=T3hTNOwzKq5dodw@mail.gmail.com>
	<53A007F7.6020103@linux.vnet.ibm.com>
	<CAK5sBcECq5sN9CnUhWLPoYnFnPz64JM_6CVRBwjz8Q2=X5_t=A@mail.gmail.com>
	<53A01039.2020302@linux.vnet.ibm.com>
Date: Tue, 17 Jun 2014 17:25:00 +0530
X-Google-Sender-Auth: Z05oD0Bzj6YJ52H7yDEymauJdnc
Message-ID: <CAK5sBcH6Yw0rdfUgTPi2OhqZ5pNeD39_NUguT4NFR4hrK2uZgA@mail.gmail.com>
Subject: Re: Boot warnings on exynos5420 based boards
From: Sachin Kamat <sachin.kamat@samsung.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org, akpm@linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

On Tue, Jun 17, 2014 at 3:24 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 06/17/2014 03:03 PM, Sachin Kamat wrote:
>
>>> Below is an updated patch, please let me know how it goes. (You'll have to
>>> revert c47a9d7cca first, and then 56e692182, before trying this patch).
>>
>> I am unable to apply your below patch on top of the above 2 reverts.
>> Applying: CPU hotplug, smp: Execute any pending IPI callbacks before CPU offline
>> fatal: corrupt patch at line 106
>> Patch failed at 0001 CPU hotplug, smp: Execute any pending IPI
>> callbacks before CPU offline
>>
>> Even with 'patch' I get the below failures:
>> patching file kernel/smp.c
>> Hunk #2 FAILED at 53.
>> Hunk #3 FAILED at 179.
>> 2 out of 3 hunks FAILED -- saving rejects to file kernel/smp.c.rej
>>
>
> Hmm, weird. My mailer must have screwed it up.
>
> Let's try again:
>
> [In case this also doesn't work for you, please use this git tree in which
>  I have reverted the 2 old commits and added this updated patch.
>
>  git://github.com/srivatsabhat/linux.git ipi-offline-fix-v3
> ]

Unfortunately the attached patch did not apply either. Nevertheless, I
applied the
patch from your above mentioned tree. With that patch I do not see the warnings
that I mentioned in my first mail. Thanks for fixing it.

Regards,
Sachin.
