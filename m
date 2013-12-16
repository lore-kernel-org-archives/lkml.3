Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3LPQbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:31:22 -0500
Received: from smtprelay0187.hostedemail.com ([216.40.44.187]:49900 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754291Ab3LPQbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:31:20 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3874:4250:4321:5007:7652:8603:8700:9036:10004:10400:10848:11232:11658:11914:12043:12050:12266:12438:12517:12519:12555:12679:12740:13069:13311:13357:13870,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: war49_45881bb9bcc26
X-Filterd-Recvd-Size: 2476
Message-ID: <1387211476.18217.33.camel@joe-AO722>
Subject: Re: [PATCH 1/3] Introduce FW_INFO* functions and messages
From: Joe Perches <joe@perches.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 16 Dec 2013 08:31:16 -0800
In-Reply-To: <52AEF997.906@redhat.com>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>
	 <1385997579-22240-2-git-send-email-prarit@redhat.com>
	 <20131203132120.6a7ab2cd7cc99720712cbe6a@linux-foundation.org>
	 <201312041922.59181.arnd@arndb.de>
	 <20131205113016.GB3823@console-pimps.org>
	 <1386258903.10003.8.camel@joe-AO722>
	 <20131206123026.GB3597@console-pimps.org> <52AEF997.906@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 08:01 -0500, Prarit Bhargava wrote:
> Sorry everyone, I was out on PTO for the past few weeks.
> 
> 
> On 12/06/2013 07:30 AM, Matt Fleming wrote:
> > On Thu, 05 Dec, at 07:55:03AM, Joe Perches wrote:
> >> On Thu, 2013-12-05 at 11:30 +0000, Matt Fleming wrote:
> >>> On Wed, 04 Dec, at 07:22:57PM, Arnd Bergmann wrote:
> >>>> The other part I noticed about this particular patchset is that it's
> >>>> not really "firmware" as such, but specifically PC wiht ACPI that
> >>>> gets covered here. So rather than generalizing the code, another
> >>>> option would be to narrow down the scope and make it
> >>>> acpi_{warn,info,dbg} instead.
> >>>
> >>> Making this specific to ACPI runs the risk of people introducing a
> >>> multitude of new logging functions for every subsystem, e.g.
> >>> efi_{warn,info,dbg}.
> >>
> >> There are many subsystem specific logging functions:
> > 
> > Surely that's further justification to not introduce any more.
> 
> That's what I was thinking when I saw this discussion.

I have no problem with introducing more <subsystem>_<kern_level>
functions/macros.

It can reduce overall object size quite a lot.

see commits like: 227842d1176019512d24236f7fb894f0fadd30d1


