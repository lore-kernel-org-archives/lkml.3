Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935714Ab3BOPHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:07:23 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39635 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756108Ab3BOPHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:07:22 -0500
Date: Fri, 15 Feb 2013 09:07:17 -0600
From: Ben Myers <bpm@sgi.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, CAI Qian <caiqian@redhat.com>,
        xfs@oss.sgi.com
Subject: Re: [ 68/89] xfs: fix _xfs_buf_find oops on blocks beyond the
 filesystem end
Message-ID: <20130215150717.GR30652@sgi.com>
References: <20130201130207.444989281@linuxfoundation.org>
 <20130201130212.381996681@linuxfoundation.org>
 <511BB198.1080609@redhat.com>
 <20130213161845.GA20916@kroah.com>
 <20130214000730.GI26694@dastard>
 <20130214192614.GA6945@kroah.com>
 <20130214195512.GQ30652@sgi.com>
 <20130214200501.GA23036@kroah.com>
 <20130215014729.GR26694@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215014729.GR26694@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Feb 15, 2013 at 12:47:29PM +1100, Dave Chinner wrote:
> On Thu, Feb 14, 2013 at 12:05:01PM -0800, Greg Kroah-Hartman wrote:
> > On Thu, Feb 14, 2013 at 01:55:12PM -0600, Ben Myers wrote:
> > > > Ok, how about I never apply any xfs stable kernel patch, unless you send
> > > > it to stable@vger.kernel.org?
> > > 
> > > Dave has made it clear that he doesn't want to be involved in maintaining
> > > -stable kernels.
> 
> I don't think you quite understand, Ben.

...

> > > > I have that rule in place for some other subsystems that don't want me
> > > > applying stuff that they aren't aware of, and have no problem doing the same
> > > > thing here.
> > > > 
> > > > Just let me know.
> 
> Sounds like a fine idea, Greg.
> 
> > > Here are the usual suspects:
> > > 
> > > Ben Myers <bpm@sgi.com>
> > > Mark Tinguely <tinguely@sgi.com>
> > > Dave Chinner <dchinner@redhat.com>
> > > Eric Sandeen <sandeen@redhat.com>
> 
> I don't think it should be restricted to individuals.  The private
> thread used to request this backport is exactly why I didn't see
> the request in a timely fashion, and also the reason why we didn't
> end up with notifications for review going to xfs@oss.sgi.com.
> 
> Hence I'd suggest the only thing that matters is that there is a cc
> to xfs@oss.sgi.com, because that means all of the above people (and
> more) are on that list and hence have the best chance to see and
> review the backport request.
> 
> > Ok, but for this specific patch, did I do something wrong in taking it?
> 
> No, you didn't do anything wrong, Greg. Stuff went wrong on the XFS
> side of the fence.
> 
> > I guess I'll just let you send me xfs patches, is that ok with everyone
> > else? 
> 
> Sure, that would work, but only after the patches have been sent to
> xfs@oss.sgi.com for review and testing and been acked. And, of
> course, the stable submission woul dalso need to have a
> xfs@oss.sgi.com cc on it. ;)

Making sure that xfs@oss.sgi.com is Cc'd on -stable patches seems reasonable to
me.  No objection here, Dave.

-Ben
