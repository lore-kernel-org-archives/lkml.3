Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbaCTJgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:36:22 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:45945 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750960AbaCTJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:36:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:560:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2896:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:4321:5007:7652:7809:7901:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stone78_19d35fc27f608
X-Filterd-Recvd-Size: 1813
Message-ID: <1395308175.8649.67.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: Reorder maintainer addresses for PM and
 ACPI
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>
Date: Thu, 20 Mar 2014 02:36:15 -0700
In-Reply-To: <CAMuHMdXFkf0g15vY=PkeMgxhr4G2=tWhK+jd8ejiqT0bJVaxQQ@mail.gmail.com>
References: <1744772.yf52reTAmC@vostro.rjw.lan>
	 <1395282105.8649.55.camel@joe-AO722>
	 <CAMuHMdXFkf0g15vY=PkeMgxhr4G2=tWhK+jd8ejiqT0bJVaxQQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 08:58 +0100, Geert Uytterhoeven wrote:
> Hi Joe,
> 
> On Thu, Mar 20, 2014 at 3:21 AM, Joe Perches <joe@perches.com> wrote:
> >>  SUSPEND TO RAM
> >> +M:   Rafael J. Wysocki <rjw@rjwysocki.net>
> >> -M:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
> >
> > Please keep the quotes around your name.
> >
> > It makes it easier for some systems to accept
> > names with periods via copy/paste.
> 
> While for "git send-email", it's easier if I don't have to remove the one in
> the middle manually...
> 
> Anyway, scripts/get_maintainer.pl re-adds them.

A lot of people just open MAINTAINERS, root around
for sections of interest, and copy/paste.


