Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaBKHRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:17:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45507 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaBKHRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:17:20 -0500
Date: Tue, 11 Feb 2014 08:17:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Waiman Long <waiman.long@hp.com>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 0/8] locking/core patches
Message-ID: <20140211071700.GH27965@twins.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
 <20140210150230.b7f46688093ebc5c45fee870@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210150230.b7f46688093ebc5c45fee870@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 03:02:30PM -0800, Andrew Morton wrote:
> On Mon, 10 Feb 2014 20:58:20 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Hi all,
> > 
> > I would propose merging the following patches...
> > 
> > The first set is mostly from Jason and tweaks the mutex adaptive
> > spinning, AIM7 throughput numbers:
> > 

                         Jobs/min/ Jobs/sec/ Time:   Time:  Time:   Time:           Running child time
         Forks  Jobs/min   child    child parent  childU childS  std_dev   JTI   :max  :min

> > PRE:  100   2000.04  21564.90 2721.29 311.99     3.12       0.01     0.00     99
> > POST: 100   2000.04  42603.85 5142.80 311.99     3.12       0.00     0.00     99
> 
> What do these columns represent?  I'm guessing the large improvement
> was in context switches?

I pasted the header from reaim above; I'm not entirely sure what the
bloody thing does and I hate that it takes hours to get these numbers :/

Bloody stupid benchmark if you ask me.

