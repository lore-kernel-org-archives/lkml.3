Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935267Ab3DOVtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:49:41 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:33041 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934779Ab3DOVtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:49:39 -0400
From: D M German <dmg@uvic.ca>
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: helping with tracking commits across repos
Organization: University of Victoria
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca> <20130412203146.GA31283@kroah.com>
Reply-To: dmg@uvic.ca
Date: Mon, 15 Apr 2013 14:49:34 -0700
In-Reply-To: <20130412203146.GA31283@kroah.com> (Greg KH's message of "Fri, 12
	Apr 2013 13:31:46 -0700")
Message-ID: <87r4ibpiq9.fsf@mn.cs.uvic.ca>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg KH twisted the bytes to say:

 Greg> But, for the linux-next stuff, that could be very interesting.  We
 Greg> always like seeing what commits in a -rc1 release did NOT previously
 Greg> show up in linux-next.  Stephen has some tools on how to do this, it
 Greg> would be interesting to see if your tools could do something like that
 Greg> to track down the "rouge" commits that don't get community testing.


Hi Greg,

Let me see if I understood you.

I looked into commits created during 2013 that satisfy the following
condition:

* We observed them in Linus repo _before_ Linux-next (that does not
necessarily mean they didn't appear in linus before linux next)
* Are not merge commits
* Were committed in 2013 (no point of showing you 2012, i guess).

they are listed here (it takes a couple of minutes to create the list... so
it is not a realtime list, but I that can be fixed
if it is useful):

http://o.cs.uvic.ca:20810/perl/next.pl

is this what you had in mind? obviously Linus commits appear in his repo
before Next, so I could drop him from the report.

I have also added the commit that merges each commit, which is probably
useful too. If it is empty either we haven't update the data or it
was done straight into linus repo (as in 3e2e0d2c222bdf5bafd722dec1618fa6073ef372).

--daniel


--
Daniel M. German
http://turingmachine.org/
http://silvernegative.com/
dmg (at) uvic (dot) ca
replace (at) with @ and (dot) with .

 
