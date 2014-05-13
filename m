Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaEMTah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:30:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:43872 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaEMTa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:30:28 -0400
Date: Tue, 13 May 2014 21:30:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/3] sched: sched_setattr/sched_getattr fixes and
 improvements
Message-ID: <20140513193026.GI2485@laptop.programming.kicks-ass.net>
References: <536CEAEE.4010609@gmail.com>
 <20140509171640.GA30445@twins.programming.kicks-ass.net>
 <53725FDE.30006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <53725FDE.30006@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 08:09:34PM +0200, Michael Kerrisk (man-pages) wrote:
> On 05/09/2014 07:16 PM, Peter Zijlstra wrote:
> > On Fri, May 09, 2014 at 04:49:18PM +0200, Michael Kerrisk (man-pages) wrote:
> >> Peter,
> >>
> >> While looking at your sched_setattr()/sched_getatr() documentation, 
> >> I noticed a bug in the handling of -EFBIG, and a couple of places 
> >> in the code where the error handling logic could be streamlined.
> >> Patches follow.
> > 
> > Thanks!
> 
> Hi Peter,
> 
> I was a little unclear on what "Thanks" meant... Does it mean
> you plan to apply all 3 patches in your tree to go upstream?

Yeah, I queued them. They should appear in tip sometime this week or so.
