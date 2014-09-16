Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaIPVnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:43:12 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46966 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512AbaIPVnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:43:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmA2AGKuGFR5LCtm/2dsb2JhbABggw2BKoIssWsGlhaFawICAQEBgRQXAXmEBAEBBDocIxAIAxgJJQ8FJQMhE4g9vG4YGIVkiG0QAgFPB4RLBZ0JjDKJFINwKy+CSgEBAQ
Date: Wed, 17 Sep 2014 07:42:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/7] check for O_NONBLOCK in all read_iter instances
Message-ID: <20140916214254.GK4322@dastard>
References: <cover.1410810247.git.milosz@adfin.com>
 <c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com>
 <x49wq93xt5e.fsf@segfault.boston.devel.redhat.com>
 <CANP1eJF3Kxj+yOndLLS749bEy6=MmSJ1iBpPn6JPbKN3h3q87g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANP1eJF3Kxj+yOndLLS749bEy6=MmSJ1iBpPn6JPbKN3h3q87g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please don't top post!]

On Tue, Sep 16, 2014 at 03:45:52PM -0400, Milosz Tanski wrote:
> On Tue, Sep 16, 2014 at 3:27 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > Christoph Hellwig <milosz@adfin.com> writes:
> >
> > Hrm, you're not Christoph...
>
> I am not Christoph, we collaborated and he sent me this patch.

You're missing Jeff's point - have a look at the name and email
adress the mail appears to be from. It's completely mangled - forged
if you will and Linus had a major rant about doing exactly this to
patch sereies recently.  There is a perfectly acceptible way of
crediting who the patch is from correctly without resorting to games
like this.

Also, this patch doesn't have a description or a valid SOB on it....

Please read Documentation/SubmittingPatches so you get the format of
the patches correct for V2. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
