Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbaGEAsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 20:48:50 -0400
Received: from fieldses.org ([174.143.236.118]:43077 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760351AbaGEAst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 20:48:49 -0400
Date: Fri, 4 Jul 2014 20:48:47 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sachin Kamat <spk.linux@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Jul 4
Message-ID: <20140705004846.GA11659@fieldses.org>
References: <20140704164251.7dc67e07@canb.auug.org.au>
 <CAK5sBcGq54sOSzJKXrEbhAUTZZh=+9NuVh294Qxn0dQvbh-G8w@mail.gmail.com>
 <20140705011058.198ae810@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140705011058.198ae810@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 01:10:58AM +1000, Stephen Rothwell wrote:
> Hi Sachin,
> 
> On Fri, 4 Jul 2014 14:12:11 +0530 Sachin Kamat <spk.linux@gmail.com> wrote:
> >
> > Was bisecting a kernel crash on Arndale octa board (Exynos5420). It
> > points to a merge
> > commit:
> > 40556a4c485d12d324f1ea196cc30f590e564237 is the first bad commit
> > ("Merge remote-tracking branch 'nfsd/nfsd-next'").
> > 
> > How do I proceed with this?
> 
> I guess we get the owner of the tree (possibly) in question involved
> (cc'd).

Looking at the total diffstat for that branch, it's almost all contained
in fs/nfsd with a little in include/linux/sunrpc/ and net/sunrpc.  So
it's extremely unlikely that it would be causing a problem unless you're
actually testing nfsd.

> You should also post your information about the crash you are
> diagnosing as others may have seen it as well - or know what may cause
> it.

Yes, please.

--b.
