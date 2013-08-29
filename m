Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3H2DHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 23:07:20 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53159 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3H2DHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 23:07:19 -0400
Date: Wed, 28 Aug 2013 20:07:15 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Jingoo Han <jg1.han@samsung.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Mark Brown'" <broonie@kernel.org>
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Message-ID: <20130829030715.GA20317@teo>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
 <003401ce96f2$0f53b840$2dfb28c0$@samsung.com>
 <20130813090039.GA5604@mwanda>
 <20130828015834.GH10506@lizard>
 <002d01cea395$0ef33ec0$2cd9bc40$%han@samsung.com>
 <20130828083630.GF19256@mwanda>
 <20130829011848.GA16891@teo>
 <20130829020714.GA26347@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130829020714.GA26347@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 07:07:14PM -0700, 'Greg Kroah-Hartman' wrote:
> On Wed, Aug 28, 2013 at 06:18:49PM -0700, Anton Vorontsov wrote:
> > On Wed, Aug 28, 2013 at 11:36:30AM +0300, Dan Carpenter wrote:
> > > He doesn't want to take the patch.  He's the maintainer so it's his
> > > choice.  That's the end of the story.
> > 
> > Just to clarify: I don't want to take the patch for a reason, not just
> > because of my mood today. Once the patch comes in combination with another
> > patch (or a plan) that actually makes use of the wrapper function, then
> > I'd happily apply/ack it.
> > 
> > This is the same story as global checkpatch.pl fixes: they are more harm
> > than good, and without the actual use of the dev_get_platdata(), the patch
> > falls into "global checkpatch.pl fixes" category.
> 
> If you view this as a checkpatch.pl fixup

As a standalone patch I view it as a checkpatch.pl fixup.

Even the author of the patch seem to agree:

| On Thu, Aug 29, 2013 at 11:14:37AM +0900, Jingoo Han wrote:
| > This patch is a just cosmetic change.

And indeed I am against massive "just cosmetic" changes.

These changes not so much burden for me personally (it was actually easier
for me to just apply the patch without all the arguing), but for those who
actually do real bugfixes/features in the drivers: their local development
trees will produce conflicts. Solving the trivial conflicts not a problem
either, but irritating (especially realizing that you waste time resolving
conflicts because of the "just cosmetic" crap).

These days I don't code that much, but I was in that boat resolving
"cosmetic" conflicts, and I did not like it. So I'm trying to solve the
issue for drivers/power/ developers.

Thanks,

Anton
