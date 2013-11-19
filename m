Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3KSAEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:04:16 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41800 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3KSAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:04:13 -0500
Date: Tue, 19 Nov 2013 01:03:41 +0100
From: Henrik Austad <henrik@austad.us>
To: Rob Landley <rob@landley.net>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Updating 00-INDEX in Documentation/*
Message-ID: <20131119000341.GA1218@austad.us>
References: <20131028130511.GA6992@austad.us>
 <1384492143.1974.272@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384492143.1974.272@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 11:09:03PM -0600, Rob Landley wrote:
> On 10/28/2013 08:05:11 AM, Henrik Austad wrote:
> >Hi Rob, Jiri
> >Hacking away at python shows me that of the 254 subfolders 57 has
> >outdated
> >00-INDEX, either with missing files, or files that has been
> >removed. (see
> >list below)
> 
> I'm a bit behind on my email just now. (Started a new job last
> month, everything else got derailed for a bit.)
> 
> >Now, I'm quite happy to start fixing this, but what I would like
> >to know
> >before I start:
> >
> >- is it considered a waste of time? i.e. will it be worth the time
> >- what is best, a single, big patch, or a series of one patch per
> >  directory?
> >- or should someone(tm) kick whoever caused 00-INDEX to be
> >outdated, to fix
> >  it?
> 
> Go for it.

Ok, I'll work my way through the list then.

> I've had a script that does this since 2007, but it's in the context of 
> creating html indexes for the kernel.org/doc/Documentation directory

Hmm, ok, I was just planning to get the 00-INDEX files up to speed, 
anything beyond that was not on my plan.

> , and after the kernel.org breakin they never gave me rsync access back 
> (because it's not built into git and all any server ever does is run git, 
> right?) so I couldn't update it anymore. Then they decided that the 
> Documentation directory should just be a raw checkout from git with no 
> html indexes (because git), and presumably they'll be doing the same for 
> http://kernel.org/doc/menuconfig any day now (how, I couldn't tell you, 
> but it's apparently no longer my problem)...
> 
> So it's kinda hard to get enthused about it these days. I wanted to
> revive my old push to reorganize the documentation directory
> (https://lkml.org/lkml/2007/5/22/473 and such) but if the word from
> on high is that a giant raw pile of unsorted files is the optimal
> way to organize things, who am I to argue?
> 
> Same problem for kernel.org/doc/htmldocs: the ones I did way back when 
> (https://web.archive.org/web/20090327025639/http://www.kernel.org/doc/htmldocs/) 
> had both the "one big html file" version and the lots of little files 
> version and I'd watch the build logs and send patches to get the warnings 
> down, but they took that away and replaced it without even letting me 
> know they were doing that, so I've fallen out of the habit. (My 
> understanding was that the kernel.org guys officially don't care about 
> any data that isn't accessed through git, and a web browser isn't git, 
> so...)
> 
> *shrug* I suppose all it's still on the todo list somewhere. Maybe
> somewhere after reviving http://landley.net/qemu and catching that
> up to current, but it's in there...
> 
> Rob

-- 
Henrik Austad
