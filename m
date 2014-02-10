Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaBJLR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:17:26 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:19717 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492AbaBJLRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:17:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AucHAHi0+FJ5LGaB/2dsb2JhbABZgwy6fIVQgQ4XdIIlAQEFOhwjEAgDDgoJJQ8FJQMhE4gEyQwXFo5nB4Q4AQOYKpIig0Eo
Date: Mon, 10 Feb 2014 22:17:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git fixes for -rc2
Message-ID: <20140210111720.GZ13997@dastard>
References: <20140209233643.GB18016@ZenIV.linux.org.uk>
 <20140210104747.GV13997@dastard>
 <20140210105210.GA18940@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210105210.GA18940@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:52:10AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 10, 2014 at 09:47:47PM +1100, Dave Chinner wrote:
> > As i pointed out in a private thread this doesn't fix XFS.
> 
> Btw, would be nice to have a public discussion and review next time
> before a pull request appears.

The private thread was Al pointing out other O_APPEND related
problems in a reply to his pull request, so you haven't missed out
on anything. First I knew of this was that private thread....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
