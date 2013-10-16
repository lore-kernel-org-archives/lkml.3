Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958Ab3JPQiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:38:00 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48989 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760773Ab3JPQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:37:58 -0400
Date: Wed, 16 Oct 2013 09:37:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 15
Message-ID: <20131016163750.GA13416@roeck-us.net>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com>
 <525E2257.7030604@roeck-us.net>
 <20131016155055.GA20211@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016155055.GA20211@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 05:50:56PM +0200, Thierry Reding wrote:
> On Tue, Oct 15, 2013 at 10:21:27PM -0700, Guenter Roeck wrote:
> > On 10/15/2013 07:02 AM, Thierry Reding wrote:
> > >Hi all,
> > >
> > >I've uploaded today's linux-next tree to the master branch of the
> > >repository below:
> > >
> > >         git://gitorious.org/thierryreding/linux-next.git
> > >
> > >A next-20131015 tag is also provided for convenience.
> > >
> > >Gained a new conflict, but nothing too exciting. x86 and ARM default
> > >configurations build fine. I've also used an x86 allmodconfig build to
> > >check for build errors. Mark fixed most of those in the trees that he
> > >created last Thursday and Friday, so I've cherry-picked them on top of
> > >the final merge. There was one new build failure in the staging tree
> > >that was trivial to fix so I added a patch to the tree as well.
> > >
> > 
> > This build does look much better than the previous ones. I 'only' get 12 build failures
> > out of 106 configurations.
> 
> Thanks for running these!
> 
No problem - servers are up anyway. Only problem is that buildbot and gitorious
don't seem to get along, and the automatic tree update doesn't work. This means
I have to trigger tree updates manually, which I may forget once in a while.

> > Worst are powerpc builds, with 7 out of 14 builds failed.
> 
> Yes, I'm seeing those too. I used to carry a fix for many of these in
> earlier linux-next trees but since I haven't had the time to run the
> PowerPC builds in a while I haven't cherry-picked it to new trees.
> 
Are those failures due to merge conflicts, or should the fix be applied
to a contributing repository ?

Thanks,
Guenter
