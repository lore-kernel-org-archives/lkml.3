Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaIQMYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:24:55 -0400
Received: from kanga.kvack.org ([205.233.56.17]:45282 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbaIQMYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:24:53 -0400
Date: Wed, 17 Sep 2014 08:24:48 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Milosz Tanski <milosz@adfin.com>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/7] check for O_NONBLOCK in all read_iter instances
Message-ID: <20140917122448.GR24821@kvack.org>
References: <cover.1410810247.git.milosz@adfin.com> <c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com> <x49wq93xt5e.fsf@segfault.boston.devel.redhat.com> <CANP1eJF3Kxj+yOndLLS749bEy6=MmSJ1iBpPn6JPbKN3h3q87g@mail.gmail.com> <20140916214254.GK4322@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916214254.GK4322@dastard>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 07:42:54AM +1000, Dave Chinner wrote:
> [Please don't top post!]
> 
> On Tue, Sep 16, 2014 at 03:45:52PM -0400, Milosz Tanski wrote:
> > On Tue, Sep 16, 2014 at 3:27 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > > Christoph Hellwig <milosz@adfin.com> writes:
> > >
> > > Hrm, you're not Christoph...
> >
> > I am not Christoph, we collaborated and he sent me this patch.
> 
> You're missing Jeff's point - have a look at the name and email
> adress the mail appears to be from. It's completely mangled - forged
> if you will and Linus had a major rant about doing exactly this to
> patch sereies recently.  There is a perfectly acceptible way of
> crediting who the patch is from correctly without resorting to games
> like this.

Linus flamed me for that a few weeks ago.  The problem is that if one 
uses "git format-patch" to prepare a series of emails to post, that it 
users the patch's author for the From: entry.  I think that is a bug 
in git since multiple people have encountered this issue.  It's not 
like git doesn't know what one's email address is....

		-ben

> Also, this patch doesn't have a description or a valid SOB on it....
> 
> Please read Documentation/SubmittingPatches so you get the format of
> the patches correct for V2. ;)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

-- 
"Thought is the essence of where you are now."
