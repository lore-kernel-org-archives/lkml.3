Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaIAF1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:27:23 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35837 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaIAF1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:27:21 -0400
MIME-Version: 1.0
In-Reply-To: <1409548719.13507.13.camel@localhost.localdomain>
References: <1409234816-10802-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
	<CAKohpokbYkL=cYQ+9-59vPhBmbAWqhrEz7RBPj5-edDB25DPgw@mail.gmail.com>
	<1409548719.13507.13.camel@localhost.localdomain>
Date: Mon, 1 Sep 2014 10:57:21 +0530
Message-ID: <CAKohpo=VaXOcEqGmmVE4A7KtYrVEtmLpMeaRm99G5oxJyetD5Q@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: powernv: Set the cpus to nominal frequency
 during reboot/kexec
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shilpa Bhat <shilpa.bhat@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 September 2014 10:48, Shilpa Bhat <shilpa.bhat@linux.vnet.ibm.com> wrote:
> Hi Viresh,
> On Fri, 2014-08-29 at 05:33 +0530, Viresh Kumar wrote:
>> On 28 August 2014 19:36, Shilpasri G Bhat
>> <shilpa.bhat@linux.vnet.ibm.com> wrote:
>> >
>> > Changes v1->v2:
>> > Invoke .target() driver callback to set the cpus to nominal frequency
>> > in reboot notifier, instead of calling cpufreq_suspend() as suggested
>> > by Viresh Kumar.
>> > Modified the commit message.
>>
>> This changelog will get commited, is this what you want?

You skipped replying to this and commited the same mistake again..

>
> This patch ensures the cpus to kexec/reboot at nominal frequency.
> Nominal frequency is the highest cpu frequency on PowerPC at
> which the cores can run without getting throttled.
>
> If the host kernel had set the cpus to a low pstate and then it
> kexecs/reboots to a cpufreq disabled kernel it would cause the target
> kernel to perform poorly. It will also increase the boot up time of
> the target kernel. So set the cpus to high pstate, in this case to
> nominal frequency before rebooting to avoid such scenarios.
>
> The reboot notifier will set the cpus to nominal frequncy.
>
> Changes v1->v2:
> Invoke .target() driver callback to set the cpus to nominal frequency
> in reboot notifier, instead of calling cpufreq_suspend() as suggested
> by Viresh Kumar.
> Modified the commit message.

This would get commited in git changelogs and probably you don't want
this. So please place them after the three dash '-' symbols below..

> Signed-off-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
> Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---

HERE>>>>>>>>>>>

>  drivers/cpufreq/powernv-cpufreq.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)

I have already Acked this, so you could have added that yourself
on this resend.
