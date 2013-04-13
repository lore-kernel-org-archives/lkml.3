Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3DMSB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 14:01:28 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:33477 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3DMSB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 14:01:27 -0400
From: D M German <dmg@uvic.ca>
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: helping with tracking commits across repos
Organization: University of Victoria
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca> <20130412203146.GA31283@kroah.com>
Reply-To: dmg@uvic.ca
Date: Sat, 13 Apr 2013 11:01:24 -0700
In-Reply-To: <20130412203146.GA31283@kroah.com> (Greg KH's message of "Fri, 12
	Apr 2013 13:31:46 -0700")
Message-ID: <87ppxyqphn.fsf@mn.cs.uvic.ca>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 vinod> 
 vinod> 
 vinod> 
 vinod> On Fri, 2013-04-12 at 13:22 -0700, D M German wrote:
 vinod> > Hi Everybody,
 vinod> > 
 vinod> > I am professor of computer science at the University of Victoria
 vinod> > (Canada).
 vinod> > 
 vinod> > During the last year and a half, we have been trying to track the
 vinod> > commits as they move in the entire linux git repos ecosystem. We have
 vinod> > amassed a good amount of data that tell us for every commit (and in fact
 vinod> > for every unique patch inside a commit) where it has been and whether it
 vinod> > has reached linus or not ---or any other repository, as a matter of
 vinod> > fact.
 vinod> i see some of the commits shown not in linus tree, although they are...
 vinod> perhaps a bug?
 vinod> http://o.cs.uvic.ca:20810/perl/cid.pl?cid=765024697807ad1e1cac332aa891253ca4a339da
 vinod> 
 vinod> It shows the same for linus's merge!
 vinod> http://o.cs.uvic.ca:20810/perl/cid.pl?cid=cfb63bafdb87bbcdc5d6dbbca623d3f69475f118
 
Hi Vinod,

the tracking of the path-to-linus is something that is not done
automatically yet (I have to start the process manually, as there are
some issues I need to verify--it is a heuristic), but I plan to run it
automatically.

Nonetheless, it might be run once a day, so the commits of the day will
always be slightly behind.

One thing that will help me is that if any of you feel I am not tracking
your repository, please send me an email with its address.

thank you!

--daniel


--
Daniel M. German                  "Don't try to be like Jackie.
                                   There is only one Jackie...
   Jackie Chan ->                  Study computers instead"
http://turingmachine.org/
http://silvernegative.com/
dmg (at) uvic (dot) ca
replace (at) with @ and (dot) with .

 
