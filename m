Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3IYSWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:22:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39507 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750924Ab3IYSWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:22:08 -0400
Message-ID: <524329CA.8060707@free-electrons.com>
Date: Wed, 25 Sep 2013 20:22:02 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/3] rcu: Fix occurrence of "the the" in
 checklist.txt
References: <20130925011657.GA29958@linux.vnet.ibm.com> <1380071843-30362-1-git-send-email-paulmck@linux.vnet.ibm.com> <1380071843-30362-3-git-send-email-paulmck@linux.vnet.ibm.com> <20130925034739.GA2016@leaf> <20130925135527.GS9093@linux.vnet.ibm.com> <20130925153321.GA6269@leaf>
In-Reply-To: <20130925153321.GA6269@leaf>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 05:33 PM, Josh Triplett wrote:
> On Wed, Sep 25, 2013 at 06:55:27AM -0700, Paul E. McKenney wrote:
>> On Tue, Sep 24, 2013 at 08:47:39PM -0700, Josh Triplett wrote:
>>> On Tue, Sep 24, 2013 at 06:17:23PM -0700, Paul E. McKenney wrote:
>>>> From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>>>>
>>>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>>>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>>> ---
>>> See comment below.
>>>
>>>>  Documentation/RCU/checklist.txt | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
>>>> index 7703ec7..ad6cba4 100644
>>>> --- a/Documentation/RCU/checklist.txt
>>>> +++ b/Documentation/RCU/checklist.txt
>>>> @@ -203,7 +203,7 @@ over a rather long period of time, but improvements are always welcome!
>>>>  	the corresponding readers must disable preemption, possibly
>>>>  	by calling rcu_read_lock_sched() and rcu_read_unlock_sched().
>>>>  	If the updater uses synchronize_srcu() or call_srcu(),
>>>> -	the the corresponding readers must use srcu_read_lock() and
>>>> +	the corresponding readers must use srcu_read_lock() and
>>> I think this may have actually been a typo for "then", as in "If the
>>> updater uses ..., then the corresponding readers must use ...".
>> Good point -- that would make the sentence construction parallel with
>> the surrounding sentences.  Updated patch below.
>>
>> 							Thanx, Paul
Good catch! Thanks!

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

