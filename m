Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbbA1CMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:12:47 -0500
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:41538 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933350AbbA1CMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:12:45 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:69:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2859:2911:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4425:5007:6120:6261:6671:6672:7576:7875:7901:8599:8987:9025:9388:10004:10400:10848:10967:11232:11658:11914:12043:12438:12517:12519:12555:12740:13007:13008:13025:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: teeth98_1784a0781a813
X-Filterd-Recvd-Size: 2028
Date: Tue, 27 Jan 2015 21:12:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Subject: Re: [PATCH 3.10 06/32] scripts/recordmcount.pl: There is no -m32
 gcc option on Super-H anymore
Message-ID: <20150127211240.29083dff@gandalf.local.home>
In-Reply-To: <54C83C21.5080707@physik.fu-berlin.de>
References: <20150128012627.081285723@linuxfoundation.org>
	<20150128012627.996535068@linuxfoundation.org>
	<54C83C21.5080707@physik.fu-berlin.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 02:32:17 +0100
John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> wrote:

> On 01/28/2015 02:26 AM, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> > 
> > commit 1caf6aaaa47471831d77c75f094d4e00ad1ec808 upstream.
> > 
> > Compiling SH with gcc-4.8 fails due to the -m32 option not being
> > supported.
> 
> JFTR, I didn't test with earlier kernels than 3.18 yet but I assume
> earlier versions will just compile fine as well.
> 
> Here's the log of a successful build of 3.18 with the patch applied:
> 
> >
> http://buildd.debian-ports.org/status/fetch.php?pkg=linux&arch=sh4&ver=3.18.3-1~exp1&stamp=1422284071

I doubt it would have an issue with earlier kernels. Earlier compilers
are another story.

-- Steve
