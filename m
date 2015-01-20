Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbbATQMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:12:13 -0500
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:45224 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752380AbbATQMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:12:12 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:196:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1622:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2859:2896:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6120:6261:6671:7875:7903:8700:9025:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12555:12663:12740:13007:13025:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: war88_2eeacf3a64b11
X-Filterd-Recvd-Size: 1743
Date: Tue, 20 Jan 2015 11:12:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH][v3.2] Revert: x86, 64bit, mm: Mark data/bss/brk to nx
Message-ID: <20150120111201.100f4e98@gandalf.local.home>
In-Reply-To: <1421769966.31046.195.camel@decadent.org.uk>
References: <20150119164926.168e8101@gandalf.local.home>
	<1421705231.31046.191.camel@decadent.org.uk>
	<20150119171902.3877f9ee@gandalf.local.home>
	<1421769966.31046.195.camel@decadent.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015 16:06:06 +0000
Ben Hutchings <ben@decadent.org.uk> wrote:

> On Mon, 2015-01-19 at 17:19 -0500, Steven Rostedt wrote:
> > On Mon, 19 Jan 2015 22:07:11 +0000
> > Ben Hutchings <ben@decadent.org.uk> wrote:
> >  
> > > Yes, I know this needs fixing.  It also broke suspend/resume on SMP
> > > machines since that involves offlining and onlining CPUs 1-n.
> > 
> > OK, as long as you know. Also, have you seen my other patch?
> > 
> > http://marc.info/?l=linux-kernel&m=142150909924885
> 
> Yes, I saw that and have filed it away for whenever I start working on
> the next 3.2 release.

OK,

I'm going to hold off releasing another 3.2-rt until then.

-- Steve
