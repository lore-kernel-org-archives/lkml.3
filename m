Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3CASzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:55:10 -0500
Received: from multi.imgtec.com ([194.200.65.239]:15200 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3CASzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:55:09 -0500
Message-ID: <5130F978.9040604@imgtec.com>
Date: Fri, 1 Mar 2013 18:54:48 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
References: <5130DD94.2060408@imgtec.com> <CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
In-Reply-To: <CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_01_18_55_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/13 18:03, Linus Torvalds wrote:
> On Fri, Mar 1, 2013 at 8:55 AM, James Hogan <james.hogan@imgtec.com> wrote:
>>
>> Please pull the following changes in addition to my previous arch/metag
>> pull request. See the tag (below) for details. The shortlog is a bit
>> inflated unfortunately as it includes the previous pull request too.
>> I've marked where the new changes begin though.
> 
> Yeah, that would be a no. I finally got to look at the new
> architectures and be ready to pull them, and you just made sure I
> won't pull this.
> 
> This is exactly the kind of crap I don't want to see in *any* pull
> requests, much less for a new sub-area.
> 
>>       metag: copy devicetree to non-init memory
>>       metag: prom.h: remove declaration of metag_dt_memblock_reserve()
>>       metag: Provide dma_get_sgtable()
>>       Merge commit 'burying unused conditionals'
>>       metag: remove GENERIC_SIGALTSTACK
>>       Merge commit 'irq_work: Remove CONFIG_HAVE_IRQ_WORK'
>>       metag: remove select CONFIG_HAVE_IRQ_WORK
>>       Merge commit 'make CONFIG_EXPERIMENTAL invisible and default'
>>       metag: remove CONFIG_EXPERIMENTAL from defconfigs
>>       Merge commit 'default SET_PERSONALITY() in linux/elf.h'
>>       metag: remove SET_PERSONALITY()
> 
> Why the f*ck are you doing back-merges? There is no excuse for even a
> single one. And here you have just about one back-merge per commit.
> 
> No, no no.
> 
> At least you have explanations, but you already had one from before,
> now you added four more. Don't do it. Let me know about fixups, or
> just wait for me to pull, but doing back-merges for trivial issues
> just makes things worse, and makes it much harder to see what the heck
> is up.

Okay thanks for the info, and sorry about that!

The original back-merge (in first merge request) was due to a dependency
on something that at the time was in linux-next, and I believe that's
the way dependencies are supposed to be dealt with for linux-next, which
is also supposed to be what I ask you to pull.

Are you okay just pulling the first merge request and I'll clean up this
one once it's pulled, or would you like me to rebase the whole thing?

Thanks
James

