Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3KOFJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:09:13 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35896 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab3KOFJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:09:08 -0500
Date: Thu, 14 Nov 2013 23:09:03 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: Updating 00-INDEX in Documentation/*
To: Henrik Austad <henrik@austad.us>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20131028130511.GA6992@austad.us> (from henrik@austad.us on Mon
	Oct 28 08:05:11 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1384492143.1974.272@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 08:05:11 AM, Henrik Austad wrote:
> Hi Rob, Jiri
> Hacking away at python shows me that of the 254 subfolders 57 has  
> outdated
> 00-INDEX, either with missing files, or files that has been removed.  
> (see
> list below)

I'm a bit behind on my email just now. (Started a new job last month,  
everything else got derailed for a bit.)

> Now, I'm quite happy to start fixing this, but what I would like to  
> know
> before I start:
> 
> - is it considered a waste of time? i.e. will it be worth the time
> - what is best, a single, big patch, or a series of one patch per
>   directory?
> - or should someone(tm) kick whoever caused 00-INDEX to be outdated,  
> to fix
>   it?

Go for it.

I've had a script that does this since 2007, but it's in the context of  
creating html indexes for the kernel.org/doc/Documentation directory,  
and after the kernel.org breakin they never gave me rsync access back  
(because it's not built into git and all any server ever does is run  
git, right?) so I couldn't update it anymore. Then they decided that  
the Documentation directory should just be a raw checkout from git with  
no html indexes (because git), and presumably they'll be doing the same  
for
http://kernel.org/doc/menuconfig any day now (how, I couldn't tell you,  
but it's apparently no longer my problem)...

So it's kinda hard to get enthused about it these days. I wanted to  
revive my old push to reorganize the documentation directory  
(https://lkml.org/lkml/2007/5/22/473 and such) but if the word from on  
high is that a giant raw pile of unsorted files is the optimal way to  
organize things, who am I to argue?

Same problem for kernel.org/doc/htmldocs: the ones I did way back when  
(https://web.archive.org/web/20090327025639/http://www.kernel.org/doc/htmldocs/)  
had both the "one big html file" version and the lots of little files  
version and I'd watch the build logs and send patches to get the  
warnings down, but they took that away and replaced it without even  
letting me know they were doing that, so I've fallen out of the habit.  
(My understanding was that the kernel.org guys officially don't care  
about any data that isn't accessed through git, and a web browser isn't  
git, so...)

*shrug* I suppose all it's still on the todo list somewhere. Maybe  
somewhere after reviving http://landley.net/qemu and catching that up  
to current, but it's in there...

Rob