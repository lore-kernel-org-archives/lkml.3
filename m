Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3JQOr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:47:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab3JQOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:47:56 -0400
Date: Thu, 17 Oct 2013 07:49:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>
Subject: Re: [PATCH -next] misc: fix various misc/mic/host/ build errors
Message-ID: <20131017144906.GB23234@kroah.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C481E.1010908@infradead.org>
 <20131016192648.GA19637@kroah.com>
 <525EEBD4.7070800@infradead.org>
 <20131016194440.GA14416@kroah.com>
 <20131016203024.GA6579@mithrandir>
 <20131016203727.GB1633@kroah.com>
 <20131017140224.GA32734@ulmo.nvidia.com>
 <20131017141629.GP2443@sirena.org.uk>
 <20131017142138.GC32734@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017142138.GC32734@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 04:21:39PM +0200, Thierry Reding wrote:
> On Thu, Oct 17, 2013 at 03:16:29PM +0100, Mark Brown wrote:
> > On Thu, Oct 17, 2013 at 04:02:25PM +0200, Thierry Reding wrote:
> > > On Wed, Oct 16, 2013 at 01:37:27PM -0700, Greg Kroah-Hartman wrote:
> > 
> > > > Yes, I'll do that as part of my normal tree submission process.
> > 
> > > Actually, ensuring correct merge order won't be enough, will it? That
> > > doesn't magically fixes that the function's signature actually changed.
> > 
> > > Shouldn't the update of the sysfs_get_dirent() call be fixed within the
> > > same patch that updates the sysfs_get_dirent() signature?
> > 
> > They're applied in different trees so they're both OK by themselves,
> > it's the merge that brings the two together that needs to do the fixup.
> 
> Right, as long as the person doing that merge remembers to do that. It
> sounds like the thing that could easily be forgotten. But Linus has been
> doing this for a long time, so I'm sure he'll know what to look for. I'm
> curious though, are maintainers supposed to mention it when sending pull
> requests with such a dependency?

Sometimes, if we remember, we do, sometimes we don't :)
