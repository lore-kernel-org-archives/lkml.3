Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaBKViE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:38:04 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:47712 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaBKViB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:38:01 -0500
Message-ID: <52FA9813.7020003@hp.com>
Date: Tue, 11 Feb 2014 16:37:23 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 0/8] locking/core patches
References: <20140210195820.834693028@infradead.org> <20140210150230.b7f46688093ebc5c45fee870@linux-foundation.org> <20140211071700.GH27965@twins.programming.kicks-ass.net> <20140211000330.d791513d.akpm@linux-foundation.org> <20140211084502.GA26063@gmail.com> <20140211085743.GJ27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140211085743.GJ27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 03:57 AM, Peter Zijlstra wrote:
> On Tue, Feb 11, 2014 at 09:45:02AM +0100, Ingo Molnar wrote:
>>> heh, yes, it's stupid how long many benchmarks take.  Ditch it.  A
>>> change like this should be testable with a 30-line microbenchmark
>>> which runs in 5 seconds tops.
>> Another very nice option would be to stick the relevant workload
>> patterns into 'perf bench', calibrate it to emit similar figures (and
>> double check the speedup is similar as well) and thus make it an AIM7
>> work-alike microbenchmark.
> /me stares at Jason and Waiman.. :-)

It shouldn't be too hard to get the mutex exercising portion of AIM7 
into perf. I will discuss with Jason about this when we finish some of 
the high-priority tasks we currently have.

-Longman
