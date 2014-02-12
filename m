Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaBLO1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:27:16 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57806 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBLO1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:27:14 -0500
Date: Wed, 12 Feb 2014 09:27:00 -0500
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build failure after merge of the final tree (cgroup
 tree related)
Message-ID: <20140212142700.GJ24490@htj.dyndns.org>
References: <20140212162500.242e91e4cc3541b992fa3a0c@canb.auug.org.au>
 <20140212063933.GB7984@mtj.dyndns.org>
 <20140212214743.22fd2d8e1889ae69986e58aa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212214743.22fd2d8e1889ae69986e58aa@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 09:47:43PM +1100, Stephen Rothwell wrote:
> Hi, Tejun,
> 
> On Wed, 12 Feb 2014 01:39:33 -0500 Tejun Heo <tj@kernel.org> wrote:
> >
> > On Wed, Feb 12, 2014 at 04:25:00PM +1100, Stephen Rothwell wrote:
> > > Presumably caused by commit 2bd59d48ebfb ("cgroup: convert to kernfs")
> > > (see the comment in commit 1ff6bbfd13ca ("arm, pm, vmpressure: add
> > > missing slab.h includes")).  I wonder how mane more builds are broken by
> > > this :-(
> > 
> > Dang, I was feeling pretty safe as kbuild bot was reporting build
> > successes.  We better fix them at any rate.  David / Sam, can you
> > please pick this one up?
> 
> It really needs to go into the tree with the cgroup commit so it doesn't
> break there.

Hmmm... I see.  I'll route the patch once Dave or Sam acks it.

Thanks!

-- 
tejun
