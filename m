Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3KZAwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:52:08 -0500
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:45932 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751691Ab3KZAwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:52:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:16:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1605:1711:1730:1747:1777:1792:2110:2393:2559:2562:2691:2828:2893:2897:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4037:4321:4362:5007:6691:7652:7903:9040:10004:10400:10463:10464:10848:11232:11658:11914:12517:12519:12663:12740:13095:13160:13229:13618:13869:14037:14039,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: peace56_1150238a9b557
X-Filterd-Recvd-Size: 4158
Message-ID: <1385427119.20100.47.camel@joe-AO722>
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Johannes =?ISO-8859-1?Q?L=F6thberg?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Nov 2013 16:51:59 -0800
In-Reply-To: <20131125101807.GA13385@gmail.com>
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
	 <528ACB6A.1040809@zytor.com> <20131119072241.GB32478@gmail.com>
	 <20131119103408.GA3640@pd.tnic> <1384883323.17783.35.camel@joe-AO722>
	 <20131119182306.GD3515@pd.tnic> <528BACCB.1090604@zytor.com>
	 <1384885733.17783.37.camel@joe-AO722> <20131125101807.GA13385@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 11:18 +0100, Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> > On Tue, 2013-11-19 at 10:24 -0800, H. Peter Anvin wrote:
> > > I'll take a proper cleanup,
> > > but just whitespace... just pointless churn.
> > What in your view would be "a proper cleanup" for a20.c?
> 
> If a newbie does a meaningful, complete, well done cleanup patch then 
> congratulations and any such help is welcome.
> 
> If you as a more experienced kernel developer do a cleanup as part of 
> some real work then sure, all such cleanups are welcome and they are a 
> natural part of development work.
> 
> So a standalone cleanup patch to a20.c from _you_ would probably not 
> qualify, almost by definition: your first patch was applied 7 years 
> ago,

More than 10, but I only note that by looking in a mirror.

> you are by far not a newbie anymore, yet you seem to be mostly 
> stuck on the 'cleanups and trivialities' level! Sheesh!
> 
> My message to the buerocrat Joe Perches is: please leave trivial and 
> printk patches to newbies, you need to raise to the next level of 
> kernel development already.

Were I employed to improve the kernel, I'd probably subsume
my neatening tendencies to the needs of the employer.

Thankfully, I'm not employed to improve Linux and I can
choose what I want to do without need to fix bugs that cause
entities to lose money, customers or profit.  Nor do I have
to add hardware support for whatever new gadget comes along.

> FYI, Linux is a meritocracy, not a bureaucracy:

I don't believe that Linux is a meritocracy at all.

It has become a business entity all to itself and is nearly
completely supported and maintained by profit-seeking
ventures such as the one that employs you.

Is any major maintainer an unpaid, unremunerated volunteer?

> creating self-serving 
> churn and attention-seeking

I think you've a odd view of what I submit.

I've a hard time believing I'm either self-serving or
attention-seeking.  I'll advance my belief that I'm rather
unassuming and not prone to spotlights.

If I see what I believe a defect in either logic or style,
I either comment on it if it's a patch, or submit a patch
myself.  I provide comments a fair amount.

> but unimportant patches is not the way to 
> gain kernel development credibility long term, and eventually people 
> start protecting against your increasing abuse of the development 
> process.

Do please reread of this thread as what I did was comment
on a particular patch by Johannes and suggested that it was
not likely a necessary thing to change.  What I tried to help
him with was understanding what, if anything, actually needed
to be or could be changed in the file.

>  IMHO.

<smile>
Perhaps you could dial down your humility a bit.
Perhaps you'll reread and see if it seems humble to you.

cheers, Joe

