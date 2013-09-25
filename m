Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3IYWX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:23:58 -0400
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:57354 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755003Ab3IYWX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:23:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2561:2564:2682:2685:2828:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:7809:8599:9025:9388:10004:10049:10400:10848:11232:11658:11914:12043:12114:12517:12519:12740:13069:13311:13357:13846,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: band14_796536470b74a
X-Filterd-Recvd-Size: 2170
Message-ID: <1380147827.17366.25.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: wimax@linuxwimax.org is subscribers-only
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Date: Wed, 25 Sep 2013 15:23:47 -0700
In-Reply-To: <20130925200950.GA10751@redhat.com>
References: <1380138892.17366.24.camel@joe-AO722>
	 <20130925200950.GA10751@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 16:09 -0400, Dave Jones wrote:
> On Wed, Sep 25, 2013 at 12:54:52PM -0700, Joe Perches wrote:
>  > Mark it so.
[]
>  > diff --git a/MAINTAINERS b/MAINTAINERS
[]
>  > @@ -4414,7 +4414,7 @@ F:	arch/x86/kernel/tboot.c
>  >  INTEL WIRELESS WIMAX CONNECTION 2400
>  >  M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
>  >  M:	linux-wimax@intel.com
>  > -L:	wimax@linuxwimax.org
>  > +L:	wimax@linuxwimax.org (subscribers-only)
>  >  S:	Supported
>  >  W:	http://linuxwimax.org
>  >  F:	Documentation/wimax/README.i2400m
>  > @@ -9225,7 +9225,7 @@ F:	drivers/media/rc/winbond-cir.c
>  >  WIMAX STACK
>  >  M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
>  >  M:	linux-wimax@intel.com
>  > -L:	wimax@linuxwimax.org
>  > +L:	wimax@linuxwimax.org (subscribers-only)
>  >  S:	Supported
>  >  W:	http://linuxwimax.org
>  >  F:	Documentation/wimax/README.wimax
> 
> The W: link is dead. 
> 
> Given wimax never really took off, is there any point in keeping this in the kernel at all ?
> We turned off the drivers in Fedora a while ago, and just threw out the userspace parts.
> I wouldn't be surprised to learn of other distributions doing the same.

Inaky?
Are you doing any work on this at all?
Should this be deleted?


