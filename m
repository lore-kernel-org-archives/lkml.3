Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaB1B3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 20:29:21 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58080 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaB1B3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 20:29:19 -0500
X-Originating-IP: 172.56.33.66
Date: Thu, 27 Feb 2014 17:29:10 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (akpm-current tree related)
Message-ID: <20140228012907.GB9890@thin>
References: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
 <20140226100234.GA23064@thin>
 <20140227100026.1cc909f2722b16b6d11a7b91@canb.auug.org.au>
 <20140227022128.GB23659@thin>
 <20140227134057.6492e7e2bcbb592f71bef8d5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227134057.6492e7e2bcbb592f71bef8d5@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:40:57PM +1100, Stephen Rothwell wrote:
> Hi Josh,
> 
> On Wed, 26 Feb 2014 18:21:29 -0800 Josh Triplett <josh@joshtriplett.org> wrote:
> >
> > On Thu, Feb 27, 2014 at 10:00:26AM +1100, Stephen Rothwell wrote:
> > > Please check the build results overnight tonight (for next-20140227 at
> > > http://kisskb.ellerman.id.au/linux-next) and submit any more fixes for
> > > the allnoconfig build errors.
> > 
> > Checking that site, I don't see any other instances of failures caused
> > by allnoconfig.  If I'm missing some, could you please point me to the
> > page on that site I'm missing?
> 
> That is because your patch was reverted in yesterday's (next-20140226)
> linux-next.  You will need to look tomorrow (next-20140227) sometime.

It looks like the next-20140227 builds have shown up, and I only see one
additional allnoconfig build failure exposed by my patch (TTY dependency
on cris arch-v10).  I sent a patch for that one.

I *think* that should have it covered; let me know if you see any
other failures.

- Josh Triplett
