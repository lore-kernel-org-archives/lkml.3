Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080Ab3DPANv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:13:51 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46595 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934152Ab3DPANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:13:49 -0400
From: D M German <dmg@uvic.ca>
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: helping with tracking commits across repos
Organization: University of Victoria
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca> <20130412203146.GA31283@kroah.com>
	<87r4ibpiq9.fsf@mn.cs.uvic.ca> <20130415230923.GA2417@kroah.com>
Reply-To: dmg@uvic.ca
Date: Mon, 15 Apr 2013 17:13:45 -0700
In-Reply-To: <20130415230923.GA2417@kroah.com> (Greg KH's message of "Mon, 15
	Apr 2013 16:09:23 -0700")
Message-ID: <87mwsznxhi.fsf@mn.cs.uvic.ca>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 Greg KH twisted the bytes to say:

 >> http://o.cs.uvic.ca:20810/perl/next.pl

 Greg> Yes, that's a great thing.  Maybe the ability to see the subject: line
 Greg> of the commit somewhere easier than having to click through to the patch
 Greg> would be nice, so we can just glance at the report and say, "Look at all
 Greg> of the btrfs patches that showed up out of nowhere, what happened?"

 Greg> Oh, and if you could do it for a specific kernel release, not a date
 Greg> range, that would be nice (i.e. report for 3.9-rc1, 3.8-rc1, 3.7-rc1,
 Greg> etc.)

What would be the simplest approach to getting the date? I suspect that
it can be done by doing some command line magic in Linus git repo.

 >> is this what you had in mind? obviously Linus commits appear in his repo
 >> before Next, so I could drop him from the report.

 Greg> That's just a tiny number so it's probably not needed.

 >> I have also added the commit that merges each commit, which is probably
 >> useful too. If it is empty either we haven't update the data or it
 >> was done straight into linus repo (as in 3e2e0d2c222bdf5bafd722dec1618fa6073ef372).

I's not difficult to do. I'll take care of it.

--dmg


--
Daniel M. German                  "Trying is the first step
   Homer Simpson ->                towards failure."
http://turingmachine.org/
http://silvernegative.com/
dmg (at) uvic (dot) ca
replace (at) with @ and (dot) with .

 
