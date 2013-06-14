Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3FNGSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 02:18:12 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:11227 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab3FNGSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 02:18:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQPAMe0ulF5LHzw/2dsb2JhbABagwmDBLcJhTYEAYEGF3SCIwEBBTocIxAIAxgJJQ8FJQMhE4gNuwEWjhSBHQeDYAOXQIodhyaBWIFJKg
Date: Fri, 14 Jun 2013 16:18:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [Trivial PATCH 25/33] xfs: Convert use of typedef ctl_table to
 struct ctl_table
Message-ID: <20130614061807.GY29338@dastard>
References: <cover.1371177118.git.joe@perches.com>
 <1cd76f83a114f3bc5bf6450bc71098aa2c6baa33.1371177118.git.joe@perches.com>
 <20130614052104.GX29338@dastard>
 <1371188006.31941.45.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371188006.31941.45.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 10:33:26PM -0700, Joe Perches wrote:
> On Fri, 2013-06-14 at 15:21 +1000, Dave Chinner wrote:
> > On Thu, Jun 13, 2013 at 07:37:50PM -0700, Joe Perches wrote:
> > > This typedef is unnecessary and should just be removed.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > Looks fine, Joe.
> > 
> > Acked-by: Dave Chinner <dchinner@redhat.com>
> > 
> > How do you want us to handle this? Push it through the XFS tree or
> > are you going to send it on up yourself?
> 
> Hi Dave.
> 
> I'd prefer you pick it up.
> 
> These are all pretty trivial patches, but Jiri
> typically doesn't pick them up for months.
> 
> I expect I'll have to resend whatever maintainers
> don't pick up in 6 months or so.

No worries, I'll add it to my current 3.11 patchset.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
