Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3KOAdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 19:33:47 -0500
Received: from relay3.sgi.com ([192.48.152.1]:37549 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752540Ab3KOAdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 19:33:40 -0500
Date: Thu, 14 Nov 2013 18:33:38 -0600
From: Ben Myers <bpm@sgi.com>
To: Dave Chinner <david@fromorbit.com>
Cc: elder@kernel.org, Mark Tinguely <tinguely@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
        Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH] update xfs maintainers
Message-ID: <20131115003338.GF1935@sgi.com>
References: <20131107220208.GY1935@sgi.com>
 <527C0F64.3010906@sgi.com>
 <527C4B27.6020205@redhat.com>
 <527CC50D.4060905@redhat.com>
 <20131108180337.GO10553@sgi.com>
 <20131108193424.GA11052@infradead.org>
 <20131108204605.GA1935@sgi.com>
 <527D4E8D.3000109@redhat.com>
 <20131108220309.GB1935@sgi.com>
 <20131114062226.GN6188@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114062226.GN6188@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 05:22:26PM +1100, Dave Chinner wrote:
> On Fri, Nov 08, 2013 at 04:03:10PM -0600, Ben Myers wrote:
> > From: Ben Myers <bpm@sgi.com>
> > 
> > xfs: update maintainers 
> > 
> > Add Dave as maintainer of XFS.
> > 
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> > ---
> >  MAINTAINERS |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: b/MAINTAINERS
> > ===================================================================
> > --- a/MAINTAINERS	2013-11-08 15:20:18.935186245 -0600
> > +++ b/MAINTAINERS	2013-11-08 15:22:50.685245977 -0600
> > @@ -9387,8 +9387,8 @@ F:	drivers/xen/*swiotlb*
> >  
> >  XFS FILESYSTEM
> >  P:	Silicon Graphics Inc
> > +M:	Dave Chinner <dchinner@fromorbit.com>
> >  M:	Ben Myers <bpm@sgi.com>
> > -M:	Alex Elder <elder@kernel.org>
> >  M:	xfs@oss.sgi.com
> >  L:	xfs@oss.sgi.com
> >  W:	http://oss.sgi.com/projects/xfs
> 
> Reviewed-by: Dave Chinner <david@fromorbit.com>

Applied.  ;)
