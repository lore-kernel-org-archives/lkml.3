Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3H3OFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:05:08 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54619 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3H3OFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:05:05 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXmt1oKSguM4iXfHBPFR6MWWWL8w=KC+_c8y212+ckFnw@mail.gmail.com>
References: <52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<20130830094857.GA14502@gmail.com>
	<CA+icZUX5F8NtZkc1WsFZC8ggs0K7O=dk2iyhwCDi7FQz+7cHeQ@mail.gmail.com>
	<CA+icZUVKkVuOCf1h-g8-XZ=Kjt6aLF7Yh9Mt90hbNa7q0jsvQA@mail.gmail.com>
	<CA+icZUVnfVcYdc7XHyM9oA5GF-HG35JghWNabE4pgvBvTh1E0g@mail.gmail.com>
	<20130830103633.GG10002@twins.programming.kicks-ass.net>
	<CA+icZUWYNGWYeVfGZy13wdrXgJaC_ZNS6ZkSMW5Ger3MkPkXSw@mail.gmail.com>
	<20130830105215.GH10002@twins.programming.kicks-ass.net>
	<CA+icZUXmt1oKSguM4iXfHBPFR6MWWWL8w=KC+_c8y212+ckFnw@mail.gmail.com>
Date: Fri, 30 Aug 2013 16:05:03 +0200
Message-ID: <CA+icZUXHB548C6ozf2Kme+UJwDqUqRNAoRMtJ3t65xCHKG_xvA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:57 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Aug 30, 2013 at 12:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, Aug 30, 2013 at 12:44:29PM +0200, Sedat Dilek wrote:

[...]

>>> If you tell me where you discuss perf issues I can describe the problem.
>>
>> On this list, start a new thread CC ingo, acme and me. There's also an
>> IRC channel but I keep forgetting what the official channel is and I'm
>> likely not on it. I do tend to abuse irc.oftc.net/#linux-rt for it since
>> most people are on there anyway.
>
> Hi rebel :-)!
>
> I was away from IRC for quite a year.
> I will write some words...
>

Here we go.

- Sedat -

[1] http://marc.info/?l=linux-kernel&m=137786590626809&w=2
