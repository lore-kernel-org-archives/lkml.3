Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3FGFkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:40:39 -0400
Received: from 1wt.eu ([62.212.114.60]:36102 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3FGFki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:40:38 -0400
Date: Fri, 7 Jun 2013 07:40:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>, dann frazier <dannf@debian.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 010/184] usermodehelper: introduce umh_complete(sub_info)
Message-ID: <20130607054015.GH14633@1wt.eu>
References: <20130604172130.718498876@1wt.eu> <1370580600.4021.72.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370580600.4021.72.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:50:00AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:21 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Oleg Nesterov <oleg@redhat.com>
> > 
> > commit b3449922502f5a161ee2b5022a33aec8472fbf18 upstream
> > 
> > Preparation.  Add the new trivial helper, umh_complete().  Currently it
> > simply does complete(sub_info->complete).
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > [dannf: Adjusted to apply to Debian's 2.6.32]
> 
> Dann's backports are mostly missing his Signed-off-by.  (We don't
> usually bother with this in the Debian patch queue, but probably ought
> to do so when backporting.)

Agreed, it would be cleaner. Dann, would you please pass me your
s-o-b for this one before the release ?

Thanks,
Willy

