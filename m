Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3LIXza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:55:30 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32930 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab3LIXz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:55:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkMSAFpXplJ5LHyk/2dsb2JhbABZgwc4pGUDjzGFUIEpF3SCJQEBBTocIxAIAw4KCSUPBSUDIROIAQ7AZBcWjnoHhDMDmBOBMZBjgz0o
Date: Tue, 10 Dec 2013 10:55:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        Kees Cook <keescook@google.com>,
        Dwight Engen <dwight.engen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, Greg KH <gregkh@linuxfoundation.org>,
        xfs@oss.sgi.com, stable@vger.kernel.org
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131209235523.GW31386@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
 <20131209121534.GE4278@hercules>
 <CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc xfs list, cc stable@vger.kernel.org]

On Mon, Dec 09, 2013 at 08:17:09AM -0500, Josh Boyer wrote:
> On Mon, Dec 9, 2013 at 7:15 AM, Luis Henriques
> <luis.henriques@canonical.com> wrote:
> > On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
> >> Hi,
> >>
> >> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
> >> capability check to free eofblocks ioctl") is a security fix that was
> >> never sent to -stable? From what I can see, it was introduced in 3.8
> >> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
> >> XFS_IOC_FREE_EOFBLOCKS ioctl").
> >>
> >> I don't see this in the 3.8.y tree. Should it be added there and newer?
> >
> > Thanks Kees, I'm queuing it for the 3.11 kernel.
> 
> There's also this one:
> 
> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/57654
> 
> It fixes CVE-2013-6382

First I've heard about it there being a CVE for that bug. Since when
has it been considered best practice to publish CVEs without first
(or ever) directly contacting the relevant upstream developers?

But, regardless of how broken I think the CVE process is, commit
071c529 ("xfs: underflow bug in xfs_attrlist_by_handle()") should be
picked up by the stable kernels.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
