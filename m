Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3DXG0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:26:41 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:54454 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3DXG0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:26:39 -0400
From: D M German <dmg@uvic.ca>
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: helping with tracking commits across repos
Organization: University of Victoria
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca> <20130412203146.GA31283@kroah.com>
	<87r4ibpiq9.fsf@mn.cs.uvic.ca> <20130415230923.GA2417@kroah.com>
	<87mwsznxhi.fsf@mn.cs.uvic.ca> <20130416044049.GA6162@kroah.com>
Reply-To: dmg@uvic.ca
Date: Tue, 23 Apr 2013 23:26:35 -0700
In-Reply-To: <20130416044049.GA6162@kroah.com> (Greg KH's message of "Mon, 15
	Apr 2013 21:40:49 -0700")
Message-ID: <87k3nsv3z8.fsf@mn.cs.uvic.ca>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 Greg> On Mon, Apr 15, 2013 at 05:13:45PM -0700, D M German wrote:
 >> 
 >> 
 >> Greg KH twisted the bytes to say:
 >> 
 >> >> http://o.cs.uvic.ca:20810/perl/next.pl
 >> 
 Greg> Yes, that's a great thing.  Maybe the ability to see the subject: line
 Greg> of the commit somewhere easier than having to click through to the patch
 Greg> would be nice, so we can just glance at the report and say, "Look at all
 Greg> of the btrfs patches that showed up out of nowhere, what happened?"
 >> 
 Greg> Oh, and if you could do it for a specific kernel release, not a date
 Greg> range, that would be nice (i.e. report for 3.9-rc1, 3.8-rc1, 3.7-rc1,
 Greg> etc.)
 >> 
 >> What would be the simplest approach to getting the date? I suspect that
 >> it can be done by doing some command line magic in Linus git repo.

 Greg> You want to look at the commits from the last major release (i.e. 3.8)
 Greg> to the -rc1 release, (i.e. 3.9-rc1).  You can't look at the dates,
 Greg> that's not going to reflect when the patch landed in Linus's branch.

Hi Greg,

It took me longer than expected, but I finally got it working.

I have a heuristic to estimate when a commit is merged by Linus. It
seems to work well in commits since 2008. 

The commits that mark the releases are nicely labeled by Linus.  Since I
know in which commit any commit is merged by Linus I can determine what
release the commit is part of. 

Take a look:

http://o.cs.uvic.ca:20810/perl/next.pl

It is only doing 2013, but if needed, I can expand the range of
dates. Is suspect older are not that interesting any more.

I still have to "cron" the update of some data to fully do this report
automatically. I hope to do that very soon.

It will help to have some extra eyes. If anybody finds a bug please let
me know.

I also improved some of the other reports to include the log of the
commit whenever is makes sense.

I haven't tried the suggestions on how to reduce space... that is my
next goal.

--daniel

--
Daniel M. German                  "Beauty is the first test; there is no
                                   permanent place in the world for ugly
   G. H. Hardy ->                  mathematics."
http://turingmachine.org/
http://silvernegative.com/
dmg (at) uvic (dot) ca
replace (at) with @ and (dot) with .

 
