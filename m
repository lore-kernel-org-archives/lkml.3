Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaCRNUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:20:39 -0400
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:51553 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754904AbaCRNUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:20:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3870:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tank28_790ce8c0aa64c
X-Filterd-Recvd-Size: 2071
Message-ID: <1395148827.2812.54.camel@joe-AO722>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Date: Tue, 18 Mar 2014 06:20:27 -0700
In-Reply-To: <CAMuHMdVxTQDdpcdjZZRSrvT8cmuT2AkE1q6WaSWey8U+PuVX2w@mail.gmail.com>
References: <20140318002822.372705594@telegraphics.com.au>
	 <1395112756.20860.1.camel@joe-AO722>
	 <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
	 <1395146702.2812.47.camel@joe-AO722>
	 <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
	 <1395148051.2812.51.camel@joe-AO722>
	 <CAMuHMdVxTQDdpcdjZZRSrvT8cmuT2AkE1q6WaSWey8U+PuVX2w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 14:13 +0100, Geert Uytterhoeven wrote:
> > no_printk keeps all side effects like
> > performing any function calls made by the
> > statement or accessing any volatiles.
> That's true...
> > Using
> > do { if (0) no_printk(fmt, ##__VA_ARGS__); } while (0)
> > does not have any side-effects.
> ... but all current users in include/ have the side-effects.

I believe that's intentional, but <shrug>.

I prefer debug statements to have _no_
side effects when not compiled-in/enabled.

Opinions vary.

cheers, Joe

