Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbbA1UOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:14:48 -0500
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:35189 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754444AbbA1UOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:14:41 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6120:6261:7875:7903:9025:10004:10400:10848:10967:11232:11658:11914:12043:12438:12517:12519:12555:12663:12740:13069:13149:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flesh75_2821a1b234210
X-Filterd-Recvd-Size: 2429
Date: Wed, 28 Jan 2015 06:57:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/3] ftrace: introduce nohotpatch function attribute
Message-ID: <20150128065754.4466f07b@gandalf.local.home>
In-Reply-To: <20150128053645.GA4633@osiris>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
	<1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
	<20150126093701.699763dc@gandalf.local.home>
	<20150127061941.GA4591@linux.vnet.ibm.com>
	<20150127094228.50e642fc@gandalf.local.home>
	<20150128053645.GA4633@osiris>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 06:36:45 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Tue, Jan 27, 2015 at 09:42:28AM -0500, Steven Rostedt wrote:
> > On Tue, 27 Jan 2015 07:19:42 +0100
> > Dominik Vogt <vogt@linux.vnet.ibm.com> wrote:
> >  
> > > While the kernel may use only profiling or hotpatch at the same
> > > time, Gcc is able to generate both for the same function.
> > 
> > Understood, but would that be useful for the kernel?
> 
> Right now not. We may change that anyway in the future if needed.
> 
> Steven, how do we proceed with this small series?
> 
> Since there don't seem to be any objections, I'll repost with the
> changed notrace define. However I think the whole stuff should go
> upstream via the ftrace tree. Is that ok with you?

I can take it or you can, I'm fine either way. If you want to take it,
just add my Acked-by. If you prefer me to take it, just let me know.

-- Steve

> 
> FWIW, the s390 gcc hotpatch feature was merged in the meantime:
> https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=11762b8363737591bfb9c66093bc2edf289b917f

