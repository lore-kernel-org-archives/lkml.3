Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaJ1OAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:00:30 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56683 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaJ1OA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:00:27 -0400
MIME-Version: 1.0
In-Reply-To: <20141028133131.GA1445@sirus.conectiva>
References: <CAGqmi77uR2Nems6fE_XM1t3a06OwuqJP-0yOMOQh7KH13vzdzw@mail.gmail.com>
 <20141025213201.005762f9.akpm@linux-foundation.org> <20141028133131.GA1445@sirus.conectiva>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 28 Oct 2014 16:59:45 +0300
Message-ID: <CAGqmi76b0oUMAsAvBt=PwaxF5JZXcckSdWe2=bL_pXaiUFFCXQ@mail.gmail.com>
Subject: Re: UKSM: What's maintainers think about it?
To: Marco A Benatto <marco.benatto@mandriva.com.br>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-28 16:31 GMT+03:00 Marco A Benatto <marco.benatto@mandriva.com.br>:
> Hi All,
>
> I'm not mantainer at all, but I've being using UKSM for a long time and remember
> to port it to 3.16 family once.
> UKSM seems good and stable and, at least for me, doesn't raised any errors.
> AFAIK the only limitation I know (maybe I has been fixed already) it isn't able
> to work together with zram stuff due to some race-conditions.
>
> Cheers,
>
> Marco A Benatto
> Mandriva OEM Developer
>

http://kerneldedup.org/forum/forum.php?mod=viewthread&tid=106
As i did find, uksm not conflicting with zram (or zswap - on my system).

---
Offtop:
Why i open up question about UKSM?

May be we (as community, who want to help) can split out UKSM in
"several patches" in independent git repo. For allowing maintainers to
review this.

Is it morally correct?

UKSM code licensed under GPL and as i think we can feel free for port
and adopt code (with indicating the author)

Please, fix me if i mistake or miss something.
This is just stream of my thoughts %_%
---

> On Sat, Oct 25, 2014 at 09:32:01PM -0700, Andrew Morton wrote:
>> On Sat, 25 Oct 2014 22:25:56 +0300 Timofey Titovets <nefelim4ag@gmail.com> wrote:
>>
>> > Good time of day, people.
>> > I try to find 'mm' subsystem specific people and lists, but list
>> > linux-mm looks dead and mail archive look like deprecated.
>> > If i must to sent this message to another list or add CC people, let me know.
>>
>> linux-mm@kvack.org is alive and well.

So cool, thanks for adding 'mm' to CC.

>> > If questions are already asked (i can't find activity before), feel
>> > free to kick me.
>> >
>> > The main questions:
>> > 1. Somebody test it? I see many reviews about it.
>> > I already port it to latest linux-next-git kernel and its work without issues.
>> > http://pastebin.com/6FMuKagS
>> > (if it matter, i can describe use cases and results, if somebody ask it)
>> >
>> > 2. Developers of UKSM already tried to merge it? Somebody talked with uksm devs?
>> > offtop: now i try to communicate with dev's on kerneldedup.org forum,
>> > but i have problems with email verification and wait admin
>> > registration approval.
>> > (i already sent questions to
>> > http://kerneldedup.org/forum/home.php?mod=space&username=xianai ,
>> > because him looks like team leader)
>> >
>> > 3. I just want collect feedbacks from linux maintainers team, if you
>> > decide what UKSM not needed in kernel, all other comments (as i
>> > understand) not matter.
>> >
>> > Like KSM, but better.
>> > UKSM - Ultra Kernel Samepage Merging
>> > http://kerneldedup.org/en/projects/uksm/introduction/
>>
>> It's the first I've heard of it.  No, as far as I know there has been
>> no attempt to upstream UKSM.
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Have a nice day,
Timofey.
