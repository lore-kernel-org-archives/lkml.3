Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaEEJxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:53:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59637 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbaEEJx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:53:28 -0400
Message-ID: <53675F8F.3030107@gmail.com>
Date: Mon, 05 May 2014 11:53:19 +0200
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
References: <53020C9D.1050208@gmail.com> <20140428081858.GX13658@twins.programming.kicks-ass.net> <535FA467.2070403@gmail.com> <20140429160441.GU11096@twins.programming.kicks-ass.net> <5360D9E5.9080206@gmail.com> <20140430130937.GH30445@twins.programming.kicks-ass.net> <20140503124355.5d927080518051ca507bc381@gmail.com> <536735E0.7020204@gmail.com> <20140505072114.GY11096@twins.programming.kicks-ass.net> <53674094.2020307@gmail.com> <20140505074736.GZ11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140505074736.GZ11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 09:47 AM, Peter Zijlstra wrote:
> On Mon, May 05, 2014 at 09:41:08AM +0200, Michael Kerrisk (man-pages) wrote:
>>>> But, in that case, I need to know the
>>>> copyright and license you want to use. Please see
>>>> https://www.kernel.org/doc/man-pages/licenses.html
>>>
>>> GPLv2 + DOC (not v2+) sounds good.
>>
>> I'm a little unclear here. Do you or don't you mean
>> https://www.kernel.org/doc/man-pages/licenses.html#gpl
>> ?
> 
> A variant with out the +, just like I do my kernel code, no greater gpl
> versions. However, 
> 
>> (Note, I'd really prefer to stick to one of those licenses
>> (without variants). (My personal preference is the "verbatim"
>> license, which is the most widely used one.) There's already
>> do many licenses in in man-pages...
> 
> Verbatim is OK with me I suppose. 

And don't neglect to mention who the copyright is to please.

> Its only text after all, who cares
> about that :-)
> /me runs for the hills.

Well, apparently you care, so thanks ;-)

 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
