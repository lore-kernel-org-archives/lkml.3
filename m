Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaJVGyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:54:47 -0400
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:50317 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753357AbaJVGyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:54:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2565:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3657:3770:3865:3866:3867:3870:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4659:5007:6117:6261:7901:7903:8599:9010:9025:9388:10004:10400:10848:11026:11232:11253:11658:11854:11914:12043:12214:12296:12517:12519:12555:12679:12740:12776:13019:13069:13095:13311:13357:13894:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flame75_809ea48369e30
X-Filterd-Recvd-Size: 2659
Message-ID: <1413960882.18654.2.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: Update Zynq maintainer record
From: Joe Perches <joe@perches.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 21 Oct 2014 23:54:42 -0700
In-Reply-To: <ba5ded105f25449a8ccd35f3109ff2de@BL2FFO11FD019.protection.gbl>
References: <1413927103-31358-1-git-send-email-soren.brinkmann@xilinx.com>
	 <ba5ded105f25449a8ccd35f3109ff2de@BL2FFO11FD019.protection.gbl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 08:29 +0200, Michal Simek wrote:
> On 10/21/2014 11:31 PM, Soren Brinkmann wrote:
> >  - add myself as reviewer for Zynq
> >  - add entry to cover Zynq clock drivers
> >  - add entry to cover Xilinx DMA drivers
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  MAINTAINERS | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a20df9bf8ab0..07eecdddbe8b 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1543,6 +1543,7 @@ F:	arch/arm/mach-pxa/include/mach/z2.h
> >  
> >  ARM/ZYNQ ARCHITECTURE
> >  M:	Michal Simek <michal.simek@xilinx.com>
> > +R:	Sören Brinkmann <soren.brinkmann@xilinx.com>
> 
> this is fine.
> 
> >  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> >  W:	http://wiki.xilinx.com
> >  T:	git git://git.xilinx.com/linux-xlnx.git
> > @@ -1552,7 +1553,9 @@ F:	drivers/cpuidle/cpuidle-zynq.c
> >  F:	drivers/block/xsysace.c
> >  N:	zynq
> >  N:	xilinx
> > +F:	drivers/clk/zynq/
> 
> this is handled by N: zynq
> 
> >  F:	drivers/clocksource/cadence_ttc_timer.c
> > +F:	drivers/dma/xilinx/
> 
> ditto.

F: specific paths are better than N: file names
because get_maintainers doesn't add the patches
submitters for N: entries.

> >  F:	drivers/i2c/busses/i2c-cadence.c
> >  F:	drivers/mmc/host/sdhci-of-arasan.c
> >  
> 
> Thanks,
> Michal
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



