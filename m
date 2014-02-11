Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaBKI6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:58:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47319 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:58:04 -0500
Date: Tue, 11 Feb 2014 09:57:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 0/8] locking/core patches
Message-ID: <20140211085743.GJ27965@twins.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
 <20140210150230.b7f46688093ebc5c45fee870@linux-foundation.org>
 <20140211071700.GH27965@twins.programming.kicks-ass.net>
 <20140211000330.d791513d.akpm@linux-foundation.org>
 <20140211084502.GA26063@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211084502.GA26063@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 09:45:02AM +0100, Ingo Molnar wrote:
> > heh, yes, it's stupid how long many benchmarks take.  Ditch it.  A 
> > change like this should be testable with a 30-line microbenchmark 
> > which runs in 5 seconds tops.
> 
> Another very nice option would be to stick the relevant workload 
> patterns into 'perf bench', calibrate it to emit similar figures (and 
> double check the speedup is similar as well) and thus make it an AIM7 
> work-alike microbenchmark.

/me stares at Jason and Waiman.. :-)
