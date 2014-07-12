Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaGLBkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:40:22 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:60420 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752809AbaGLBkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:40:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:7652:7903:8531:8957:8985:9025:9388:10004:10400:10848:11232:11658:11914:12043:12114:12517:12519:12682:12740:13069:13161:13229:13311:13357:14089:14096:14097:14106:21080,0,RBL:none,CacheIP:none,Ba
X-HE-Tag: sense99_1fc5258fc4c3e
X-Filterd-Recvd-Size: 2085
Message-ID: <1405129216.6751.18.camel@joe-AO725>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 11 Jul 2014 18:40:16 -0700
In-Reply-To: <20140712013444.GA30368@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
	 <20140712013444.GA30368@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 18:34 -0700, Greg KH wrote:
> On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> > A simple script to run checkpatch --fix for various types of
> > of cleanups.
> > 
> > This script is useful primarily for staging.
> > 
> > This reformats code to a more CodingStyle conforming style,
> > compiles it, verifies that the object code hasn't changed,
> > and git commits it too.
> 
> And 'git commits' it?

The thought I had was to made it easier to
submit "my first kernel patch" correctly.
like that tuxradar article you wrote a few
years ago.

http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel

> Heh, I should just run this myself to clean up
> staging and beat everyone else to it...

At least for the whitespace noise, you could
but I hope it'll encourage a few more people
to try kernel patching instead.

> I know some people already have private versions of these things, might
> as well make it public for all to abuse :)

And I hope they can improve it too as it's
just a brainless little script.

