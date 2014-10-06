Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaJFQ5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:57:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41751 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaJFQ5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:57:37 -0400
Message-ID: <5432C9F2.2030503@zytor.com>
Date: Mon, 06 Oct 2014 09:57:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [PATCH v4 0/2] x86_64,entry: Clear NT on entry and speed up switch_to
References: <cover.1412189265.git.luto@amacapital.net> <CALCETrVmoNP-vXVv_EpFtccsqjDMnUN9cxJc4pNU=Nb1_ekMZg@mail.gmail.com> <5432C62C.704@zytor.com> <CALCETrXp+EkMzrA2PobS2rBfNjrD+JnAEOp5bYPz_P4bsBqCjg@mail.gmail.com>
In-Reply-To: <CALCETrXp+EkMzrA2PobS2rBfNjrD+JnAEOp5bYPz_P4bsBqCjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 09:45 AM, Andy Lutomirski wrote:
> On Mon, Oct 6, 2014 at 9:41 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 10/06/2014 09:39 AM, Andy Lutomirski wrote:
>>> On Wed, Oct 1, 2014 at 11:49 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> Anish Bhatt noticed that user programs can set RFLAGS.NT before
>>>> syscall or sysenter, and the kernel entry code doesn't filter out
>>>> NT.  This causes kernel C code and, depending on thread flags, the
>>>> exit slow path to run with NT set.
>>>>
>>>
>>> Quick ping: now that the merge window is (sort of) open, what's
>>> happening with these patches?
>>>
>>> Thanks,
>>> Andy
>>>
>>
>> My preference would be to queue them up for 3.19 since they arrived late
>> in the 3.18 cycle.
> 
> I see nothing wrong with deferring patch 2 for 3.19, but deferring
> patch 1, which is tagged for stable, for an entire release seems a bit
> silly to me.
> 

Yes, that is probably going to get pushed later in this merge window;
that is usually how we deal with that sort of thing.

	-hpa


