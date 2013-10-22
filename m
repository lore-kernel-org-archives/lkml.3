Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3JVT3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:29:06 -0400
Received: from smtprelay0034.hostedemail.com ([216.40.44.34]:47837 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753690Ab3JVT3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:29:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4427:4659:5007:6119:6120:7652:7809:7901:7903:7904:9025:10004:10400:10848:11232:11658:11914:12050:12324:12517:12519:12555:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: death49_14b9f49f89d2d
X-Filterd-Recvd-Size: 2480
Message-ID: <1382470141.2041.98.camel@joe-AO722>
Subject: Re: [PATCH 01/15] tpm: MAINTAINERS: Add myself as tpm maintainer
From: Joe Perches <joe@perches.com>
To: Ashley D Lai <adlai@linux.vnet.ibm.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, james.l.morris@oracle.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 22 Oct 2013 12:29:01 -0700
In-Reply-To: <1382469734.3742.3.camel@buffalo>
References: <1382464440-7579-1-git-send-email-peterhuewe@gmx.de>
	 <1382469734.3742.3.camel@buffalo>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 14:22 -0500, Ashley D Lai wrote:
> On Tue, 2013-10-22 at 19:53 +0200, Peter Huewe wrote:
> > Since I'm actively maintaining the tpm subsystem for a few months now,
> > it's time to step up and be an official maintainer for the tpm subsystem,
> > atleast until I hear something different from my company.
> > 
> > The maintaining is done solely in my private time, out of private interest.
> > Speaking only on behalf of myself, trying to be as vendor neutral as possible.
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> >  MAINTAINERS |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 4fde706..936adb4 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -8475,6 +8475,7 @@ F:	drivers/media/usb/tm6000/
> >  TPM DEVICE DRIVER
> >  M:	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
> >  M:	Ashley Lai <ashley@ashleylai.com>
> > +M:	Peter Huewe <peterhuewe@gmx.de>
> >  M:	Rajiv Andrade <mail@srajiv.net>
> >  W:	http://tpmdd.sourceforge.net
> >  M:	Marcel Selhorst <tpmdd@selhorst.net>
> 
> Peter has been a great help on maintaining the tpm driver.  Thanks for
> volunteering, you have my support on this.

It'd be nice if all the M entries were clustered
together and probably nice too if the
W:	http://www.sirrix.com
entry removed.  I didn't notice anything useful
there about the driver.
Maybe there's a specific page about the driver
buried on the corporate website.  If so, that
specific page should be linked instead.

