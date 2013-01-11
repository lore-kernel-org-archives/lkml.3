Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3AKBPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 20:15:42 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:57988 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3AKBPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 20:15:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hzqqQPA1cd4uPoCd73d5rBj8cGpv=VnB6CrCpdjjwr1xw@mail.gmail.com>
References: <CAFTL4hxWdV96dO_KCOnvc4O1zutvnW6eGZ950d+qwnCSHb9NpQ@mail.gmail.com>
	<20121203094906.4cbfcfc0ad3f0319895a162d@canb.auug.org.au>
	<CAFTL4hzqqQPA1cd4uPoCd73d5rBj8cGpv=VnB6CrCpdjjwr1xw@mail.gmail.com>
Date: Fri, 11 Jan 2013 02:15:39 +0100
Message-ID: <CAFTL4hw-WM5ur6Z-1DPMMvregEJr_CfcaeBOHV-nawh+NKi+VA@mail.gmail.com>
Subject: Re: Request for tree inclusion
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/3 Frederic Weisbecker <fweisbec@gmail.com>:
> 2012/12/2 Stephen Rothwell <sfr@canb.auug.org.au>:
>> Well, these are a bit late (I expected Linus to release v3.7 today), but
>> since Ingo has not piped in over the weekend, I have added them from today
>> after the tip tree merge.
>
> Yeah sorry to submit that so late. Those branches are in pending pull
> requests to the -tip tree and I thought about relying on the
> propagation of -tip into -next as usual. But Ingo has been very busy
> with numa related work during this cycle. So until these branches get
> merged in -tip, I'm short-circuiting a bit the -next step before it
> becomes too late for the next merge window.
>
>>
>> I have called them fw-cputime, fs-sched and fw-nohz respectively and
>> listed you as the only contact in case of problems.
>
> Ok.
>
>> If these are to be
>> long term trees included in linux-next, I would prefer that you use
>> better branch names - otherwise, if they are just short term, please tell
>> me to remove them when they are finished with.
>
> They are definitely short term. I'll tell you once these can be dropped.
>
> Thanks a lot!

Hi Stephen!

fw-cputime and fs-sched have been merged so you can now remove these
branches from next.

But fw-nohz remains. In the meantime I have created a branch named nohz/next:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
        nohz/next

This branch currently refers to fw-nohz HEAD (aka nohz/printk-v8) and
this is also the place where I'll gather -next materials in the future
instead of the multiple branches you're currently pulling.
So could you please remove fw-nohz (nohz/printk-v8) as well from -next
but include nohz/next instead?

Thanks!
