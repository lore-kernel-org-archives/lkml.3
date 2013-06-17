Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3FQWkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:40:01 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57604 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751050Ab3FQWj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:39:59 -0400
Date: Mon, 17 Jun 2013 17:39:58 -0500
From: Ben Myers <bpm@sgi.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Joe Perches <joe@perches.com>, Alex Elder <elder@kernel.org>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [Trivial PATCH 25/33] xfs: Convert use of typedef ctl_table to
 struct ctl_table
Message-ID: <20130617223958.GI20932@sgi.com>
References: <cover.1371177118.git.joe@perches.com>
 <1cd76f83a114f3bc5bf6450bc71098aa2c6baa33.1371177118.git.joe@perches.com>
 <20130614052104.GX29338@dastard>
 <1371188006.31941.45.camel@joe-AO722>
 <20130614061807.GY29338@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614061807.GY29338@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Fellas,

On Fri, Jun 14, 2013 at 04:18:07PM +1000, Dave Chinner wrote:
> On Thu, Jun 13, 2013 at 10:33:26PM -0700, Joe Perches wrote:
> > On Fri, 2013-06-14 at 15:21 +1000, Dave Chinner wrote:
> > > On Thu, Jun 13, 2013 at 07:37:50PM -0700, Joe Perches wrote:
> > > > This typedef is unnecessary and should just be removed.
> > > > 
> > > > Signed-off-by: Joe Perches <joe@perches.com>
> > > 
> > > Looks fine, Joe.
> > > 
> > > Acked-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > How do you want us to handle this? Push it through the XFS tree or
> > > are you going to send it on up yourself?
> > 
> > Hi Dave.
> > 
> > I'd prefer you pick it up.
> > 
> > These are all pretty trivial patches, but Jiri
> > typically doesn't pick them up for months.
> > 
> > I expect I'll have to resend whatever maintainers
> > don't pick up in 6 months or so.
> 
> No worries, I'll add it to my current 3.11 patchset.

Applied it. No need to repost. Thanks Joe!

Reviewed-by: Ben Myers <bpm@sgi.com>

-Ben
