Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3DPMu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:50:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52145 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3DPMuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:50:55 -0400
Date: Tue, 16 Apr 2013 13:50:52 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: D M German <dmg@uvic.ca>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: helping with tracking commits across repos
Message-ID: <20130416125052.GC3054@hercules>
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
 <20130412203146.GA31283@kroah.com>
 <87ppxyqphn.fsf@mn.cs.uvic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppxyqphn.fsf@mn.cs.uvic.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Sat, Apr 13, 2013 at 11:01:24AM -0700, D M German wrote:
>  vinod> 
>  vinod> 
>  vinod> 
>  vinod> On Fri, 2013-04-12 at 13:22 -0700, D M German wrote:
>  vinod> > Hi Everybody,
>  vinod> > 
>  vinod> > I am professor of computer science at the University of Victoria
>  vinod> > (Canada).
>  vinod> > 
>  vinod> > During the last year and a half, we have been trying to track the
>  vinod> > commits as they move in the entire linux git repos ecosystem. We have
>  vinod> > amassed a good amount of data that tell us for every commit (and in fact
>  vinod> > for every unique patch inside a commit) where it has been and whether it
>  vinod> > has reached linus or not ---or any other repository, as a matter of
>  vinod> > fact.
>  vinod> i see some of the commits shown not in linus tree, although they are...
>  vinod> perhaps a bug?
>  vinod> http://o.cs.uvic.ca:20810/perl/cid.pl?cid=765024697807ad1e1cac332aa891253ca4a339da
>  vinod> 
>  vinod> It shows the same for linus's merge!
>  vinod> http://o.cs.uvic.ca:20810/perl/cid.pl?cid=cfb63bafdb87bbcdc5d6dbbca623d3f69475f118
>  
> Hi Vinod,
> 
> the tracking of the path-to-linus is something that is not done
> automatically yet (I have to start the process manually, as there are
> some issues I need to verify--it is a heuristic), but I plan to run it
> automatically.
> 
> Nonetheless, it might be run once a day, so the commits of the day will
> always be slightly behind.
> 
> One thing that will help me is that if any of you feel I am not tracking
> your repository, please send me an email with its address.

While looking at the repos list, I realised you are tracking some ubuntu
git trees that are not actually useful, namely:

git://kernel.ubuntu.com/roc/linux-2.6
git://kernel.ubuntu.com/rtg/net-next

I would like to ask if you could remove these two and add instead the
linux-3.5.y branch in the git://kernel.ubuntu.com/ubuntu/linux.git repo
(I'm not sure if you track the branches separately).

Cheers,
--
Luis
