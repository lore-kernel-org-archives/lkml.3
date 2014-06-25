Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbaFYWOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:14:06 -0400
Received: from smtprelay0068.hostedemail.com ([216.40.44.68]:51264 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757058AbaFYWOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:14:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7522:7652:7903:8985:9025:10004:10400:10848:10967:11026:11232:11658:11914:12043:12114:12438:12517:12519:12679:12740:13069:13160:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twig86_403ec622dba35
X-Filterd-Recvd-Size: 2351
Message-ID: <1403734440.24788.15.camel@joe-AO725>
Subject: Re: [PATCH 01/22] pci-dma-compat: Add pci_zalloc_consistent helper
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Date: Wed, 25 Jun 2014 15:14:00 -0700
In-Reply-To: <20140625145744.9cb4ec9e3ea7a63bf630eeaa@linux-foundation.org>
References: <cover.1403530604.git.joe@perches.com>
	 <2248b3ffe86cd8995a809bf7e2871f38039979c1.1403530604.git.joe@perches.com>
	 <20140625122755.152685fadbc9cffe7a298dc6@linux-foundation.org>
	 <1403733111.24788.8.camel@joe-AO725>
	 <20140625145744.9cb4ec9e3ea7a63bf630eeaa@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 14:57 -0700, Andrew Morton wrote:
> On Wed, 25 Jun 2014 14:51:51 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > > People sometimes address this by using
> > > 
> > > 	"drivers: net: ethernet: amd: use pci_zalloc_consistent"
> > > 
> > > which strikes me as utterly perverse.  We already have a nice way of
> > > representing the hierarchy and that's using '/'.
> > 
> > I used to do that until several people complained.
> 
> Slap 'em.

And get booked for assault?  No thanks.
My mild-mannered persona thinks that a poor plan.

My actual feeling is I don't much care.

btw:  https://lkml.org/lkml/2010/11/15/387

I also proposed a scheme where the prescriptive
patch subject pedants could put some pattern
into MAINTAINERS so that these subject lines
could be more automatically generated.

https://lkml.org/lkml/2010/11/16/245

> I don't know where this thing is coming from - I'd suspected there must
> be some misguided doc somewhere but I don't know where it is.  Some
> vast conspiracy against common sense.

> I don't want to be overly proscriptive here, but it's a bit maddening
> when you're skimming patch titles and cannot work out which part of the
> kernel is being patched :(

Yup.

