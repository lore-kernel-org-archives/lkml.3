Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbbAUNhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:37:54 -0500
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:43537 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752225AbbAUNhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:37:41 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4362:5007:6261:7875:7903:7904:9040:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12663:12740:13069:13311:13357:13618:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: owner25_42ef9237f6e0a
X-Filterd-Recvd-Size: 1841
Date: Wed, 21 Jan 2015 08:37:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: tidy up of trees
Message-ID: <20150121083739.1b29cfca@gandalf.local.home>
In-Reply-To: <20150121151009.0cb88a21@canb.auug.org.au>
References: <20150121151009.0cb88a21@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 15:10:09 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> [affected tree contacts are bcc'd on this email]
> 

> kconfig
> Git URL: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig.git#for-next
> 

This is my localmodconfig repo. I only use it when someone points out
something broke or I find a better way of doing something.

It doesn't get updated much because so far, I hear localmodconfig and
localyesconfig are doing everything that people like. It may not ever
get updated again if everyone (including myself) stays happy with it :-)

But in case that changes, and I need to restructure it, this will be
needed again. Should I just let this go out of next, but I'll probably
forget that it does, and still think my for-next branch is active.

If it is any extra burden on you to keep it, then I'm fine with it
falling off the radar. But if it's just "I have X repos in next, and
I'm trying to make it Y", I'd rather keep it in.

Thanks!

-- Steve
