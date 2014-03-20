Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaCTCVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:21:51 -0400
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:52078 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750737AbaCTCVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:21:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:560:599:800:960:966:973:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2828:2896:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3870:3872:3874:4250:4321:4385:5007:7652:7809:7901:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tail09_f88f2002ec28
X-Filterd-Recvd-Size: 1652
Message-ID: <1395282105.8649.55.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: Reorder maintainer addresses for PM and
 ACPI
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, Len Brown <lenb@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Date: Wed, 19 Mar 2014 19:21:45 -0700
In-Reply-To: <1744772.yf52reTAmC@vostro.rjw.lan>
References: <1744772.yf52reTAmC@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 00:00 +0100, Rafael J. Wysocki wrote:

> Reorder PM and ACPI maintainer addresses in MAINTAINERS to make
> the probability of that a bit smaller.

>  FREEZER
> +M:	Rafael J. Wysocki <rjw@rjwysocki.net>
> -M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
[]
>  HIBERNATION (aka Software Suspend, aka swsusp)
> +M:	Rafael J. Wysocki <rjw@rjwysocki.net>
> -M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
[]
>  SUSPEND TO RAM
> +M:	Rafael J. Wysocki <rjw@rjwysocki.net>
> -M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>

Please keep the quotes around your name.

It makes it easier for some systems to accept
names with periods via copy/paste.


