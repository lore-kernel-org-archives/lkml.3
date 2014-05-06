Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbaEFJlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:41:21 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934523AbaEFJlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:41:18 -0400
Message-ID: <5368AE39.1030402@nod.at>
Date: Tue, 06 May 2014 11:41:13 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] Deprecate BUG/BUG_ON in favour of BUG_AND_HALT/BUG_AND_HALT_ON
References: <1398870207-52889-1-git-send-email-paul.gortmaker@windriver.com> <CAFLxGvzhd6jwGsu9eOBtXu92JcH1PnZsR9EB_h5LihYRNS-hyQ@mail.gmail.com> <20140506073500.GA26303@gmail.com> <5368987E.7040608@nod.at> <20140506093548.GA27476@gmail.com>
In-Reply-To: <20140506093548.GA27476@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 06.05.2014 11:35, schrieb Ingo Molnar:
> 
> * Richard Weinberger <richard@nod.at> wrote:
> 
>>>> I like the idea but not the name.
>>>> What about DIE() and DIE_ON()?
>>>
>>> CRASH_ON() might be a suggestive name as well, as from the user's 
>>> point of view we are crashing her system.
>>
>> I fear such users will think "Why should I crash the kernel?". ;-)
> 
> That's exactly the impression that the naming should create in kernel 
> developers why try to add CRASH_ON() in the future: only do it as an 
> absolute last resort.
> 
> WARN_ON() and other non-destructive ways to deal with error conditions 
> are almost always preferred.

Yeah, I was actually referring to the joke where one asks to remove all BUG() and BUG_ON() to
make the kernel bug free.

Thanks,
//richard
