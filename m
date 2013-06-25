Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3FYCNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:13:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46207 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165Ab3FYCNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:13:05 -0400
X-Sasl-enc: b1QA3scrXoILvjs7eJnz3uFzrb5CCk6ALIniKqGdpID8 1372126383
Date: Mon, 24 Jun 2013 19:13:46 -0700
From: Greg KH <greg@kroah.com>
To: Peng Tao <bergwolf@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20130625021346.GA18752@kroah.com>
References: <20130619181031.8b53acc44466ba70a47e1fcd@canb.auug.org.au>
 <CA+a=Yy4z-ufq2GEtzC17TBbrNGWv6ZUzuVe=VLBH48Df=3HZxA@mail.gmail.com>
 <20130624224035.GD24099@kroah.com>
 <20130625094051.b9cf8f8950eeeeed0dd266b2@canb.auug.org.au>
 <20130624235003.GA1263@kroah.com>
 <51C8E2D9.2070304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C8E2D9.2070304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 08:22:49AM +0800, Peng Tao wrote:
> On 06/25/2013 07:50 AM, Greg KH wrote:
> >On Tue, Jun 25, 2013 at 09:40:51AM +1000, Stephen Rothwell wrote:
> >>Hi Greg,
> >>
> >>On Mon, 24 Jun 2013 15:40:35 -0700 Greg KH <greg@kroah.com> wrote:
> >>>We are running out of time, my tree is pretty much closed for 3.11 now,
> >>>should I just disable the build of this module for 3.11?
> >>That's what I've been doing - it has never been enabled in a final
> >>linux-next release.  So, it should probably just be disabled properly.
> >I agree, now disabled.
> >
> >greg k-h
> Greg,
> 
> Sorry for the delay. I've been caught up by other build failures
> that were found during my tests. I'm sending you the latest patches
> that should fix all the build errors. I've verified that we can now
> pass build on sparc/mips/s390/powerpc/x86, both 32bits and 64bits.
> Please help to queue them.
> 
> I see that you have already disabled Lustre build. Can we re-enable
> it or do we have to wait until 3.10 is released?

My trees mare now closed for 3.11, given that 3.10 will be released in
less than a week.  I'll keep patches in my to-apply mailbox, which I
will then apply after 3.11-rc1 is out, so I'll not be accepting anything
for the next 3 weeks or so.

thanks,

greg k-h
