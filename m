Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbaLDP6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:58:51 -0500
Received: from relay2.sgi.com ([192.48.180.65]:38847 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932512AbaLDP6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:58:49 -0500
Date: Thu, 4 Dec 2014 09:58:53 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Fabian Frederick <fabf@skynet.be>, Ingo Molnar <mingo@kernel.org>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [BUG] Possible locking issues in stop_machine code on 6k core
 machine
Message-ID: <20141204155853.GS4720@sgi.com>
References: <20141203204048.GJ4720@sgi.com>
 <alpine.DEB.2.11.1412032330510.16275@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412032330510.16275@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:34:04AM +0100, Thomas Gleixner wrote:
> first of all, could you please format your mail so it is actually
> readable and can be replied to?

My fault there - stupid mistake.

> If you would provide real data instead of half baken assumptions
> we might actually be able to help you.
> 
> There might be some hidden issue in the stomp machine crap, but surely
> not the one you described.

I'll return with some actual data so that others can get a better
picture of what we're seeing.  I'll also see if I can come up with a
way to reproduce the issue on a smaller configuration; might not be
possible, but attempting to do so might provide some more insight into
our problem.

Thanks for your detailed description of the code path!  I definitely
understand that our assumption can't be the actual problem here.  I'll
dig back into the issue and try to get some better information.

Thanks again!

- Alex
