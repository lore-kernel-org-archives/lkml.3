Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3HLSUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:20:03 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:64791 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3HLSUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:20:00 -0400
Date: Mon, 12 Aug 2013 20:19:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@infradead.org, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130812181956.GB19405@gmail.com>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
 <20130805081641.GA24808@gmail.com>
 <20130805082320.GA9562@infradead.org>
 <20130805083132.GE26746@gmail.com>
 <20130805083434.GA20606@infradead.org>
 <20130805090857.GA26940@gmail.com>
 <20130806061932.GA20485@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130806061932.GA20485@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Aug 05, 2013 at 11:08:57AM +0200, Ingo Molnar wrote:
> > You never replied to the original counter-arguments, such as this one from 
> > Linus:
> > 
> >   http://article.gmane.org/gmane.linux.kernel/849965
> 
> The only thing Linus sais is that it's trivial to generate a subpackage, 
> and that opofile is a desaster.  Both of them are 100% correct but at 
> the same time entirely miss the point.
> 
> Yes, oprofile was and is a desaster, but that has aboslutely nothing to 
> do with where the code lives.
> 
> And yes, it's easy to generate a subpackage, but you still need all the 
> source tree first. [...]

And the kernel source tree is not particularly hard to get so what's your 
point? ...

> [...]  There's a reason why things like X.org got split up (too fine 
> grained in my opinion, but that's another story).

X.org got split up for all the wrong reasons, it's still a unified project 
by and large, and the different components only work reliably when going 
in lockstep so it's not like there's a true ABI between them.

So I really hope you don't advocate for that.

perf is the exact opposite: no split-up the development culture because 
they are closely related, yet a relatively disciplined ABI between the 
components. In fact the ABI is higher quality exactly because development 
is more integrated and allows for ABI problems to be resolved before they 
leak out. It also allows for faster iteration of development, without 
nonsensical ABI steps pulluting the way.

> As said I very much disagree with having the userspace perf tree in the 
> kernel still, but I've also given up on the fight as I have more 
> important things to do.
> 
> And as said before it has nothing to do with the issue discussed here 
> right now.

My point is that it's a very similar meta argument: splitting up perf 
usage space would be nonsensical and harmful in a similar fashion as it 
would be harmful to split up the perf development space.

Put differently: there's strong benefits to having a unified perf 
development environment and there's equally strong benefits on the user 
side to have a unified perf usage environment that a single command 
represents.

The benefits are not absolute and not unconditional, and any costs of 
integration should be minimized to the best of our ability, but I hope you 
get the drift of my argument ...

Thanks,

	Ingo
