Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaEEHlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:41:15 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:62060 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaEEHlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:41:13 -0400
Message-ID: <53674094.2020307@gmail.com>
Date: Mon, 05 May 2014 09:41:08 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        linux-man@vger.kernel.org
Subject: Re: sched_{set,get}attr() manpage
References: <CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com> <20140214161929.GL27965@twins.programming.kicks-ass.net> <53020C9D.1050208@gmail.com> <20140428081858.GX13658@twins.programming.kicks-ass.net> <535FA467.2070403@gmail.com> <20140429160441.GU11096@twins.programming.kicks-ass.net> <5360D9E5.9080206@gmail.com> <20140430130937.GH30445@twins.programming.kicks-ass.net> <20140503124355.5d927080518051ca507bc381@gmail.com> <536735E0.7020204@gmail.com> <20140505072114.GY11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140505072114.GY11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 09:21 AM, Peter Zijlstra wrote:
> On Mon, May 05, 2014 at 08:55:28AM +0200, Michael Kerrisk (man-pages) wrote:
>> Hi Peter,
>>
>> Looks like a good set of comments from Juri. Could you revise and 
>> resubmit?
> 
> Yeah, I'll try and get it done today, but there's a few icky bugs
> waiting for my attention as well, I'll do me bestest :-)
> 
>> By the way, I assume you are just writing this page as raw text.
>> While I'd prefer to get proper man markup source, I'll add that
>> if you if you don't :-/. 
> 
> Well, learning *roff will likely take me more time than writing this
> text + all revisions so far :/ But yeah, I appreciate the grief.
> 
> Is there a TeX variant one could use to generate the *roff muck? While
> my TeX isn't entirely fresh its at least something I've done lots of.

Don't worry -- just send me the plain text; I'll do it. I appreciate 
you writing the text in the first place; I'll handle the rest--it won't
take me too long, and probably I'll find things to fix/check on the way.

>> But, in that case, I need to know the
>> copyright and license you want to use. Please see
>> https://www.kernel.org/doc/man-pages/licenses.html
> 
> GPLv2 + DOC (not v2+) sounds good.

I'm a little unclear here. Do you or don't you mean
https://www.kernel.org/doc/man-pages/licenses.html#gpl
?

(Note, I'd really prefer to stick to one of those licenses
(without variants). (My personal preference is the "verbatim"
license, which is the most widely used one.) There's already
do many licenses in in man-pages...

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
