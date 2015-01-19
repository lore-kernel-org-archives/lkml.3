Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbbASRKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:10:32 -0500
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:59122 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751501AbbASRKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:10:31 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2859:2893:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6261:6671:6672:7875:7903:7974:8599:8987:9025:9040:9388:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12555:12663:12740:13007:13008:13025:13069:13311:13357:14094:14096:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: comb65_3e90d70cec218
X-Filterd-Recvd-Size: 2413
Date: Mon, 19 Jan 2015 12:10:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts/recordmcount.pl: There is no -m32 option on
 Super-H
Message-ID: <20150119121028.5b345d0b@gandalf.local.home>
In-Reply-To: <54BCBDD4.10102@physik.fu-berlin.de>
References: <54BCBDD4.10102@physik.fu-berlin.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015 09:18:28 +0100
John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> wrote:

> Hi Steven!
> 
> >> The Super-H architecure seems to be without any maintainer.
> >> Maybe Steven cares to pick this patch up. Dunno...
> 
> > Yeah, I remember when the SH maintainer left.
> 
> > I can pick it up. How urgent is it? Does it need to go in before the
> > next merge window? And does it need to be tagged for stable?
> 
> I am one of the Debian porters of the SH port. Currently, the kernel
> package fails to build from source on our automatic build machines
> due to this bug. Here is the full build log where you can see it
> fail with gcc-4.8:

Unfortunately I don't have a 4.8 cross compiler for superH. It seems to
work fine with -m32 with 4.6 and earlier (which I do have).

> 
> >
> http://buildd.debian-ports.org/status/fetch.php?pkg=linux&arch=sh4&ver=3.16.7-ckt4-1&stamp=1421425783
> 
> Since the SH port of Debian was long time poorly maintained, this
> issue hasn't got any attention for quite a while which means the
> most current kernel version we have at the moment on SH is 3.2.0
> something. I asked Michael to submit this change on my behalf since
> he has submitted kernel patches in the past.
> 
> Thus, it would be nice if this fix could be merged ASAP upstream
> and included in all stable releases as well such that we get a
> working up-to-date kernel on SH soon.

I'll add this info as well to the change log.

-- Steve

