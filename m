Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaFEVOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:14:40 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:65499 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaFEVOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:14:39 -0400
Message-ID: <5390DDA6.2010700@gmail.com>
Date: Thu, 05 Jun 2014 14:14:14 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Steven Rostedt <rostedt@goodmis.org>, josh@joshtriplett.org,
        Joe Perches <joe@perches.com>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
References: <20140602185504.GA13569@cloud> <1401735917.7323.23.camel@joe-AO725> <20140602190951.GA13648@cloud> <1401736666.7323.25.camel@joe-AO725> <20140602231949.GV14410@dastard> <20140602235915.GB14801@cloud> <20140603011125.GW14410@dastard> <20140602213045.26219ddb@gandalf.local.home> <20140603071654.GC14410@dastard> <20140603134347.6e39f946@gandalf.local.home> <20140605040107.GA4453@dastard>
In-Reply-To: <20140605040107.GA4453@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/2014 9:01 PM, Dave Chinner wrote:
> On Tue, Jun 03, 2014 at 01:43:47PM -0400, Steven Rostedt wrote:
>> On Tue, 3 Jun 2014 17:16:54 +1000
>> Dave Chinner <david@fromorbit.com> wrote:
>>
>>
>>> If you take it to an extremes. Think about what you can test in 15
>>> minutes. Or for larger patchsets, how long it takes you to read the
>>> patchset?
>>
>> Yeah, what about that?
> 
> That testing a patch for obvious, common regressions takes no longer
> than it does to read and review the logic. 
> 
>>> IMO, every reviewer has their own developement environment and they
>>> should be at least testing that the change they are reviewing
>>> doesn't cause problems in that environment, just like they do for
>>> their own code before they post it for review.
>>
>> Let me ask you this. In the scientific community, when someone posts a
>> research project and asks their peers to review their work. Are all
>> those reviewers required to test out that paper?
>> Or are they to review it, check the math, look for cases that are
>> missed, see common errors, and other checks? I'm sure some
>> reviewers may do various tests, but others will just check the
>> logic. I'm having a very hard time seeing where Reviewed-by means
>> tested-by. I see those as two completely different tags.
> 
> We are not conducting a scientific research experiment here. We are
> conduting a very large software *engineering* project here.

Yes, software engineering.  Where software review is a manual process
of *reading* and understanding code, in all of the processes I have
been involved in at big corporations that love big process.  (Not to
claim I know of all the processes everyone else uses...)

Why can't you just let reviewed-by and tested-by mean different
things instead of one being a super-set of the other?

If you force reviewed-by to also mean tested-by then you just
shrank your available pool of reviewers.

</dead-horse beating>

> 
> So perhaps we should be using robust software engineering processes
> rather than academic peer review as the model for our code review
> process?

< snip >

Cheers,

Frank

