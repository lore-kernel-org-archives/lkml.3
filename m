Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaHNTce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:32:34 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:46874 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaHNTcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:32:33 -0400
Date: Thu, 14 Aug 2014 21:32:18 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        hskinnemoen@gmail.com, tglx@linutronix.de
Subject: Re: [tip:locking/arch] locking,arch,avr32: Fold atomic_ops
Message-ID: <20140814193218.GA26558@samfundet.no>
References: <20140531141445.GD16155@laptop.programming.kicks-ass.net>
 <tip-d325209b6000dcd13404ee946d2292e15a56718c@git.kernel.org>
 <20140814192720.GA16175@samfundet.no>
 <20140814193014.GX6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814193014.GX6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Thu 14 Aug 2014 21:30:14 +0200 or thereabout, Peter Zijlstra wrote:
> On Thu, Aug 14, 2014 at 09:27:20PM +0200, Hans-Christian Egtvedt wrote:
>> Around Thu 14 Aug 2014 10:19:44 -0700 or thereabout, tip-bot for Peter Zijlstra wrote:
>> > Commit-ID:  d325209b6000dcd13404ee946d2292e15a56718c
>> > Gitweb:     http://git.kernel.org/tip/d325209b6000dcd13404ee946d2292e15a56718c
>> > Author:     Peter Zijlstra <peterz@infradead.org>
>> > AuthorDate: Wed, 9 Apr 2014 21:51:29 +0200
>> > Committer:  Ingo Molnar <mingo@kernel.org>
>> > CommitDate: Thu, 14 Aug 2014 12:48:05 +0200
>> > 
>> > locking,arch,avr32: Fold atomic_ops
>> > 
>> > Many of the atomic op implementations are the same except for one
>> > instruction; fold the lot into a few CPP macros and reduce LoC.
>> > 
>> > This also prepares for easy addition of new ops.
>> > 
>> > Requires the asm_op because of eor.
>> > 
>> > AVR32 is a bit special in that its ADD/SUB instructions are not
>> > symmetric. Its SUB instruction allows for an 21bit immediate.
>> 
>> Fantastic, looks great.
>> 
>> Do you have any plans for merge route? I'll happily do it through the avr32
>> tree, but if it is part of another series, it makes most sense to do it
>> there.
> 
> I was thinking to keep the lot together in tip/locking/arch.
> 
> Once that lands, I'll need to clean up and send pass 3, which
> _hopefully_ will be the last, although I had vague plans for a 4th as
> well.

OK, you have my ack, so go ahead and merge when you feel fit.

-- 
mvh
Hans-Christian Egtvedt
