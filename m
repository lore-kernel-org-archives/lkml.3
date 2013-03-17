Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3CQCuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 22:50:06 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:57051 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934Ab3CQCuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 22:50:03 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Mar 2013 22:50:03 EDT
Message-ID: <51452DA6.5050302@akamai.com>
Date: Sat, 16 Mar 2013 22:42:46 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Cooks <acooks@gmail.com>
CC: Jim Cromie <jim.cromie@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: Bug involving dynamic_debug and '-p' modifier
References: <CAJtEV7ZsOd=c6_+A3W+NYBtrWAUPH7NrVEk-J+_+ZgoJQTBZVg@mail.gmail.com> <CAJtEV7YfgcxuEAj+a8SbNmsoMHaEgY1RQ1RoR=8nAi4=8qwT_w@mail.gmail.com>
In-Reply-To: <CAJtEV7YfgcxuEAj+a8SbNmsoMHaEgY1RQ1RoR=8nAi4=8qwT_w@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for the bug report. I need to send a patch to update the maintainers
file...

Haven't had a chance to look into this yet. Will get back to you.

Thanks,

-Jason



On 03/11/2013 10:28 PM, Andrew Cooks wrote:
> On Tue, Mar 12, 2013 at 9:14 AM, Andrew Cooks <acooks@gmail.com> wrote:
>> Hi Jason
>>
>> When I specify a '-p' modifier in the dynamic debug options in the
>> kernel command line, I get a kernel panic during boot. The panic
>> happens after userspace starts doing graphical stuff, but I haven't
>> been able to pinpoint exactly what.
>>
>> If I use '=_' instead of '-p', or boot to a recovery mode, or change
>> the modifier after booting using debugfs, the panic doesn't occur. For
>> example, booting to runlevel 3 with '=_', then flipping the same
>> modifier to first to '+p' and then to '-p', before starting X does not
>> result in a panic.
>>
>> Booting to runlevel 3 (or even 1!), with '-p' results in a panic, but
>> 'rdshell' is OK.
>>
>> I also tried the Red Hat kernel (just because it's installed - I
>> haven't figured out how to tell the package manager that I don't want
>> a kernel). This also panics, but it says that '-p' is not supported.
>>
>> Please let me know if you need me to do any other tests.
>>
>> '-p', panic: http://pastebin.com/8yAcBQdY
>> '-p', rdshell, no panic: http://pastebin.com/Hi2a7BZA
>>
>> --
>> a.
> Jason's mail bounced, so redirecting to Jim Cromie, who made the most
> recent significant changes to dynamic_debug...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

