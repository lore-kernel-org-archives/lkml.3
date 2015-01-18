Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbbARUBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 15:01:53 -0500
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:53592 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751051AbbARUBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 15:01:51 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2332:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:4250:4605:5007:6261:7875:7974:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: veil44_2d0043a6b5c60
X-Filterd-Recvd-Size: 2170
Date: Sun, 18 Jan 2015 15:01:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts/recordmcount.pl: There is no -m32 option on
 Super-H
Message-ID: <20150118150147.0e5d2386@gandalf.local.home>
In-Reply-To: <20150118180740.GA3587@osiris>
References: <1421537778-29001-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
	<20150118180740.GA3587@osiris>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2015 19:07:40 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Sun, Jan 18, 2015 at 12:36:15AM +0100, Michael Karcher wrote:
> > Signed-Off-By: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> > ---
> >  scripts/recordmcount.pl | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> > index 56ea99a..537c38c 100755
> > --- a/scripts/recordmcount.pl
> > +++ b/scripts/recordmcount.pl
> > @@ -255,7 +255,6 @@ if ($arch eq "x86_64") {
> >      # force flags for this arch
> >      $ld .= " -m shlelf_linux";
> >      $objcopy .= " -O elf32-sh-linux";
> > -    $cc .= " -m32";
> > 
> >  } elsif ($arch eq "powerpc") {
> >      $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
> > -- 
> > 2.1.3
> 
> The Super-H architecure seems to be without any maintainer.
> Maybe Steven cares to pick this patch up. Dunno...

Yeah, I remember when the SH maintainer left.

I can pick it up. How urgent is it? Does it need to go in before the
next merge window? And does it need to be tagged for stable?

-- Steve
