Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145Ab3JPVAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:00:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37382 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3JPVAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:00:23 -0400
Date: Wed, 16 Oct 2013 23:00:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131016210011.GH10651@twins.programming.kicks-ass.net>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
 <1381949500-501-2-git-send-email-treding@nvidia.com>
 <20131016200645.GD10651@twins.programming.kicks-ass.net>
 <20131016201410.GA26785@twins.programming.kicks-ass.net>
 <20131017073100.2cab1ffa@notabene.brown>
 <20131016203506.GJ2675@laptop.programming.kicks-ass.net>
 <20131016205114.GD6579@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016205114.GD6579@mithrandir>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:51:15PM +0200, Thierry Reding wrote:
> On Wed, Oct 16, 2013 at 10:35:06PM +0200, Peter Zijlstra wrote:
> > On Thu, Oct 17, 2013 at 07:31:00AM +1100, NeilBrown wrote:
> > > It seems to have moved to 
> > >   git://gitorious.org/thierryreding/linux-next.git
> > 
> > Uhm.. what happened to sfr and why would we trust gitorious?
> 
> sfr is on vacation. Back at the time when Mark Brown and I volunteered
> to continue doing the linux-next trees in Stephen's absence I didn't
> have a kernel.org account. Also we decided rather late that we wanted to
> do this so there was no time to set things up properly. We had to make
> do with what we had.
> 
> Today's next-20131016 tag is signed with my GPG key that I use for my
> kernel.org account as well, so that should make it about equally trust-
> worthy as anything I'd be pushing to kernel.org.

Fair enough; and thanks for doing this.
