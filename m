Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3AXN2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:28:53 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35776 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXN2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:28:47 -0500
Date: Thu, 24 Jan 2013 14:28:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
Message-ID: <20130124132841.GB5302@gmail.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
 <1357831182.5841.21.camel@marge.simpson.net>
 <50EEDEC1.9020708@redhat.com>
 <1357846213.5755.30.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357846213.5755.30.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <bitbucket@online.de> wrote:

> On Thu, 2013-01-10 at 10:31 -0500, Rik van Riel wrote: 
> > On 01/10/2013 10:19 AM, Mike Galbraith wrote:
> > > On Tue, 2013-01-08 at 17:26 -0500, Rik van Riel wrote:
> > >
> > >> Please let me know if you manage to break this code in any way,
> > >> so I can fix it...
> > >
> > > I didn't break it, but did let it play with rq->lock contention.  Using
> > > cyclictest -Smp99 -i 100 -d 0, with 3 rt tasks for pull_rt_task() to
> > > pull around appears to have been a ~dead heat.
> > 
> > Good to hear that the code seems to be robust. It seems to
> > help prevent performance degradation in some workloads, and
> > nobody seems to have found regressions yet.
> 
> I had hoped for a bit of positive, but a wash isn't surprising 
> given the profile.  I tried tbench too, didn't expect to see 
> anything at all there, and got that.. so both results are 
> positive in that respect.

Ok, that's good.

Rik, mind re-sending the latest series with all the acks and 
Reviewed-by's added?

Thanks,

	Ingo
