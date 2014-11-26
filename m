Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaKZS1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:27:10 -0500
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:48078 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751070AbaKZS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:27:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6119:6261:7875:7903:8829:10007:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: snake34_3e17b9fde8d33
X-Filterd-Recvd-Size: 2650
Message-ID: <1417026425.19695.10.camel@perches.com>
Subject: Re: [PATCH v2] ALSA: korg1212: cleanup of printk
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Nov 2014 10:27:05 -0800
In-Reply-To: <20141126104912.GA1085@sudip-PC>
References: <1416730251-5194-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <s5hh9xottl9.wl-tiwai@suse.de> <1416849910.8797.1.camel@perches.com>
	 <20141125062132.GA3380@sudip-PC> <1416941965.8358.6.camel@perches.com>
	 <20141126104912.GA1085@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 16:19 +0530, Sudip Mukherjee wrote:
> On Tue, Nov 25, 2014 at 10:59:25AM -0800, Joe Perches wrote:
> > On Tue, 2014-11-25 at 11:51 +0530, Sudip Mukherjee wrote:
> > > problems with this way:
> > > 1) macro name is little misleading - macro says printk, but we are using dev_dbg
> > > 2) if some one later wants to add something to this file, and doesnot want to use the variable name korg1212 in his function.
> > > 
> > > any suggestions ?
> > 
> > Some code is so old and unlikely to be ever used
> > again, it may be better to move it to an "ancient
> > and crufty" folder and forget about it.
> > 
> > This may be one of those.
> > 
> > If the debugging was written in a more current style,
> > it might look like this: (with various format/argument
> > mismatches fixed, formatting changes, etc)
> 
> ok. and can't we delete some of the messages like "DSP download is
> complete." and then printing the statename. there are lots of messages
> like that which is just printing the function name and the
> statename ..

Dunno.  Maybe somebody cares about the state of
the dsp download, but I doubt it as I suspect
the hardware isn't used much.

> and, even if i modify it a little and send it, most of the work has
> been done by you. so how do i send the patch in your name or add your
> name in the patch ? I have not done anything so my name should not be
> there.

<shrug> you started it.

I spend a couple minutes running a couple scripts.

I don't have the hardware, I've never looked at
that code before, do what you think appropriate.


