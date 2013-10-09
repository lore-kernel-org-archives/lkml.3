Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3JIPod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:44:33 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64803 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3JIPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:44:31 -0400
Date: Wed, 9 Oct 2013 08:44:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 9
Message-ID: <20131009154424.GA8564@roeck-us.net>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
 <20131009152906.GA8018@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009152906.GA8018@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 08:29:06AM -0700, Guenter Roeck wrote:
> On Wed, Oct 09, 2013 at 04:14:22PM +0200, Thierry Reding wrote:
> > Hi all,
> > 
> > I've uploaded today's linux-next tree to the master branch of the
> > repository below:
> > 
> >         git://gitorious.org/thierryreding/linux-next.git
> > 
> > A next-20131009 tag is also provided for convenience.
> > 
> > Gained a few conflicts, but nothing too exciting. x86, ARM, PowerPC and
> > MIPS default configurations build fine. There were some build failures
> > unrelated to the merge, most of which I fixed and added as patches on
> > top of the final merge.
> > 
> Build results:
> 	total: 110 pass: 93 skipped: 4 fail: 13
> 	[3.12-rc4: total: 110 pass: 105 skipped: 3 fail: 2]
> 
> Failed builds:
> 	alpha:allmodconfig
> 	arm:allmodconfig
> 	blackfin:defconfig
> 	i386:allyesconfig
> 	i386:allmodconfig
> 	m68k:allmodconfig
> 	mips:allmodconfig
> 	mips:nlm_xlp_defconfig
> 	powerpc:allmodconfig
> 	sparc64:allmodconfig
> 	x86_64:allmodconfig
> 	x86_64:allyesconfig
> 	xtensa:allmodconfig
> 
> Many of the failures are due to ceph:
> 
> fs/ceph/file.c: In function 'ceph_sync_read':
> fs/ceph/file.c:437:25: error: 'struct iov_iter' has no member named 'iov'
> ...
> 
Sorry, that was the result for yesterday's tree. I should have results for the
October 9 tree in a couple of hours.

Guenter
