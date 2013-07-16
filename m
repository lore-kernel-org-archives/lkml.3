Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab3GPFoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:44:25 -0400
Received: from ozlabs.org ([203.10.76.45]:41958 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab3GPFoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:44:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
In-Reply-To: <CA+55aFwHEn4ktPoM2dWkkx9VPg1HbjG4EYCRGfoLEKRSz_y8zw@mail.gmail.com>
References: <20130715155202.GC29526@xanatos> <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com> <20130715174659.GC15531@xanatos> <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com> <20130715180403.GD15531@xanatos> <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com> <20130715184642.GE15531@xanatos> <20130715191727.GC10157@1wt.eu> <CA+55aFwHEn4ktPoM2dWkkx9VPg1HbjG4EYCRGfoLEKRSz_y8zw@mail.gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 16 Jul 2013 14:22:14 +0930
Message-ID: <8738rf14zl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Mon, Jul 15, 2013 at 12:17 PM, Willy Tarreau <w@1wt.eu> wrote:
>>
>> BTW, I was amazed that you managed to get him have a much softer tone inr
>> his last e-mail, you probably found a weakness here in his management
>> process :-)
>
> Hey, I _like_ arguing, and "cursing" and "arguing" are actually not at
> all the same thing.
>
> And I really don't tend to curse unless people are doing something
> stupid and annoying. If people have concerns and questions that I feel
> are valid, I'm more than happy to talk about it.
>
> I curse when there isn't any argument. The cursing happens for the
> "you're so f*cking wrong that it's not even worth trying to make
> logical arguments about it, because you have no possible excuse" case.
>
> .. and sometimes people surprise me and come back with a valid excuse
> after all. "My whole family died in a tragic freak accident and my
> pony got cancer, and I was distracted".
>
> And then I might even tell them I'm sorry.
>
> No. Not really.

You have to be harsh with code: People mistake politeness for
uncertainty.  Whenever I said 'I prefer if you XYZ' some proportion
didn't realize I meant 'Don't argue unless you have new facts: do XYZ or
go away.'  This wastes my time, so I started being explicit.

But be gentle with people.  You've already called their baby ugly.

Cheers,
Rusty.
