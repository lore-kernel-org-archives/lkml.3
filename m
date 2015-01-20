Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbbATODR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:03:17 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:39403 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbATODQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:03:16 -0500
Message-ID: <54BE6020.5060609@hurleysoftware.com>
Date: Tue, 20 Jan 2015 09:03:12 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
References: <20150106114215.GS29390@twins.programming.kicks-ass.net> <20150106114842.GP10476@twins.programming.kicks-ass.net> <20150106120121.GB26845@kmo-pixel> <20150106122006.GW29390@twins.programming.kicks-ass.net> <54ABDB4B.7070008@hurleysoftware.com> <20150106173808.GB5280@linux.vnet.ibm.com> <54AC224C.4030903@hurleysoftware.com> <20150106192559.GF5280@linux.vnet.ibm.com> <54AC3E31.2080202@hurleysoftware.com> <20150106204753.GI5280@linux.vnet.ibm.com> <20150120003008.GA14445@linux.vnet.ibm.com>
In-Reply-To: <20150120003008.GA14445@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 07:30 PM, Paul E. McKenney wrote:
> On Tue, Jan 06, 2015 at 12:47:53PM -0800, Paul E. McKenney wrote:
>> On Tue, Jan 06, 2015 at 02:57:37PM -0500, Peter Hurley wrote:
> 
> [ . . . ]
> 
>> David Miller's call, actually.
>>
>> But the rule is that if it is an atomic read-modify-write operation and it
>> returns a value, then the operation itself needs to include full memory
>> barriers before and after (as in the caller doesn't need to add them).
>> Otherwise, the operation does not need to include memory ordering.
>> Since xchg(), atomic_xchg(), and atomic_long_xchg() all return a value,
>> their implementations must include full memory barriers before and after.
>>
>> Pretty straightforward.  ;-)
> 
> Hello again, Peter,
> 
> Were you going to push a patch clarifying this?

Hi Paul,

As you pointed out, atomic_ops.txt is for arch implementors, so I wasn't
planning on patching that file.

I've been meaning to write up something specifically for everyone else but
my own bugs have kept me from that. [That, and I'm not sure what I write
will be suitable for Documentation.]

Regards,
Peter Hurley
