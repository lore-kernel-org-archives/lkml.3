Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaDAJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:56:16 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:62675 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaDAJzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:55:52 -0400
Date: Tue, 1 Apr 2014 11:55:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
Message-ID: <20140401095548.GB1299@gmail.com>
References: <1396164244.28950.15.camel@marge.simpson.net>
 <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
 <1396239636.5361.57.camel@marge.simpson.net>
 <CA+55aFywHpvUfghS4GFc3UC1WGZx3Of+zeKHxmRNcMQMoKoiJQ@mail.gmail.com>
 <1396290426.5261.80.camel@marge.simpson.net>
 <CA+55aFwdosGtoh8=krpx9C-fT-H7OHsC0UVyXc8aNE7h=W1RxQ@mail.gmail.com>
 <1396322880.5324.37.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396322880.5324.37.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> On Mon, 2014-03-31 at 11:37 -0700, Linus Torvalds wrote: 
> > On Mon, Mar 31, 2014 at 11:27 AM, Mike Galbraith
> > <umgwanakikbuti@gmail.com> wrote:
> > >
> > > Oh, I didn't cc you because I wanted it applied instantly as ultra
> > > critical, only because the chain of events might be of interest.
> > 
> > Ok. That was my main worry, since I was in the process or releasing
> > 3.14, and I just couldn't tell if the patch was something I should
> > worry about or not.
> > 
> > And it seems that not applying it was the right thing, which is all
> > that matters by now.
> 
> Yes.  Jocular red flag was to Peter and Ingo.  I don't try to bypass 
> them, that would be plain rude.  I've been known to help maintainers 
> a little, but I don't ever try to call the shots.  They do that 
> well.

Btw., in general feel free to Cc: Linus if a fix looks truly urgent, 
as neither Peter nor me might be around on a weekend, shortly before a 
release.

Thanks,

	Ingo
