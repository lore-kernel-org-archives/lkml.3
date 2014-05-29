Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaE2XVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:21:31 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:44436 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbaE2XVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:21:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoRSAMO/h1N5LL1sPGdsb2JhbABZgwdSgnKnbgsBAQEBAQEGmBgBgQkXAwEBAQE4NYIlAQEFOhwjEAgDDgoJJQ8FJQMHGhOIQQ7XbxaFP4h9B4RABJl0lnQrLw
Date: Fri, 30 May 2014 09:21:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@gmail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz,
        fstests@vger.kernel.org
Subject: Re: Unionmount and overlayfs testsuite
Message-ID: <20140529232114.GJ6677@dastard>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
 <28592.1401382081@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28592.1401382081@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc fstests@vger.kernel.org]

On Thu, May 29, 2014 at 05:48:01PM +0100, David Howells wrote:
> 
> http://git.infradead.org/users/dhowells/unionmount-testsuite.git
> 
> Check it out and read the README file as to how to drive it.  Sorry, it's a
> bit crude.  I may rewrite it in python or perl at some point.
> 
> Make sure you turn on CONFIG_LOCKDEP before running it - you don't want to
> miss any locking conflicts!
> 
> Further tests would be appreciated.  There are no rename tests, for instance.

Rather than keeping this a standalone test suite that nobody really
knows about or runs regularly, perhaps it might be an idea to push
this toward inclusion in xfstests? We have filesystem specific test
sections that would suit this, and the test structure is actually
not all that different to what xfstests uses...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
