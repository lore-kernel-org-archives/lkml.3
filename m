Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaGKQg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:36:26 -0400
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:56985 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752811AbaGKQgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:36:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:981:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2538:2553:2559:2562:2693:2731:2828:2916:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3872:3874:4321:5007:7652:9010:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13072:13311:13357:13846:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crowd72_54baebdc9631b
X-Filterd-Recvd-Size: 2422
Message-ID: <1405096580.2796.12.camel@joe-AO725>
Subject: Re: [PATCH] Remove soon to be dead email address
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Jason Baron <jbaron@akamai.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 11 Jul 2014 09:36:20 -0700
In-Reply-To: <CAMuHMdWj=aJsxZJPM=v-z8+=yTAopPWYe5T-+ovnnuEydFuGvA@mail.gmail.com>
References: <20140711161341.GF12054@laptop.lan>
	 <CAMuHMdWj=aJsxZJPM=v-z8+=yTAopPWYe5T-+ovnnuEydFuGvA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 18:17 +0200, Geert Uytterhoeven wrote:
> On Fri, Jul 11, 2014 at 6:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > My Red Hat email address will soon cease to be; remove it from the
> > tree in order to save the interweb some bounces.

> > --- a/include/linux/jump_label.h
[]
> > - * Copyright (C) 2009-2012 Jason Baron <jbaron@redhat.com>
> > - * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
> > + * Copyright (C) 2009-2012 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
> 
> Change not mentioned in comment (there are a few more of these).

Jason's redhat email address bounces.

Here's a list of redhat email addresses in the kernel tree
that haven't had any git commit log activity in the last
couple years.

Some are false positives.

Just because people don't use an address doesn't mean
it's inactive.

---> airlie@redhat.com
---> alan@redhat.com
---> arjanv@redhat.com
---> armbru@redhat.com
---> borkmann@redhat.com
---> csnook@redhat.com
---> davem@redhat.com
---> dm-devel@redhat.com
---> dougsland@redhat.com
---> faith@redhat.com
---> gcosta@redhat.com
---> hdeller@redhat.com
---> Jes.Sorensen@redhat.com
---> mhiramat@redhat.com
---> mitr@redhat.com
---> nhorman@redhat.com
---> pzijlstr@redhat.com
---> roland@redhat.com
---> sct@redhat.com
---> shardy@redhat.com
---> twaugh@redhat.com


