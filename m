Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3HETax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:30:53 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:45619 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab3HETau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:30:50 -0400
MIME-Version: 1.0
In-Reply-To: <1375730199.22073.135.camel@gandalf.local.home>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<87siyo3qna.fsf@tassilo.jf.intel.com>
	<1375730199.22073.135.camel@gandalf.local.home>
Date: Mon, 5 Aug 2013 12:30:47 -0700
Message-ID: <CAAkRFZLXLgqn8yE-07K=KM6YyZt3aLrvvjGL=u_=nK9S5HQ9rg@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Xinliang David Li <davidxl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>, Rong Xu <xur@google.com>,
        Teresa Johnson <tejohnson@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 12:16 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2013-08-05 at 12:04 -0700, Andi Kleen wrote:
>> Steven Rostedt <rostedt@goodmis.org> writes:
>>
>> Can't you just use -freorder-blocks-and-partition?
>
> Yeah, I'm familiar with this option.
>

This option works best with FDO.   FDOed linux kernel rocks :)

>>
>> This should already partition unlikely blocks into a
>> different section. Just a single one of course.
>>
>> FWIW the disadvantage is that multiple code sections tends
>> to break various older dwarf unwinders, as it needs
>> dwarf3 latest'n'greatest.
>
> If the option was so good, I would expect everyone would be using it ;-)
>

There were lots of problems with this option -- recently cleaned
up/fixed by Teresa in GCC trunk.

thanks,

David

>
> I'm mainly only concerned with the tracepoints. I'm asking to be able to
> do this with just the tracepoint code, and affect nobody else.
>
> -- Steve
>
>
