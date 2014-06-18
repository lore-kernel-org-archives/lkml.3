Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbaFRX2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:28:25 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:58434 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752276AbaFRX2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:28:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 13,1.2,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2551:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3867:3868:3870:3871:3872:4321:4605:5007:7652:7809:7903:10008:10400:10848:11232:11658:11914:12043:12050:12517:12519:12555:12679:12740:13161:13229:13846:14093:14096:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: suit08_edf5e5b4925f
X-Filterd-Recvd-Size: 3107
Message-ID: <1403134100.14018.8.camel@joe-AO725>
Subject: Re: [PATCH] MAINTAINERS: add entry for VMware Balloon driver
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, pv-drivers@vmware.com
Date: Wed, 18 Jun 2014 16:28:20 -0700
In-Reply-To: <4389061.FeVMqoJiMc@dtor-d630.eng.vmware.com>
References: <1403132941-1394-1-git-send-email-dtor@vmware.com>
	 <20140618231742.GB7234@kroah.com>
	 <4389061.FeVMqoJiMc@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 16:19 -0700, Dmitry Torokhov wrote:
> On Wednesday, June 18, 2014 04:17:42 PM Greg Kroah-Hartman wrote:
> > On Wed, Jun 18, 2014 at 04:09:01PM -0700, Dmitry Torokhov wrote:
> > > Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> > > ---
> > > 
> > >  MAINTAINERS                |    6 ++++++
> > >  drivers/misc/vmw_balloon.c |    2 +-
> > >  2 files changed, 7 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 6c484ac..3a446e8 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -9645,6 +9645,12 @@ L:	virtualization@lists.linux-foundation.org
> > > 
> > >  S:	Supported
> > >  F:	arch/x86/kernel/cpu/vmware.c
> > > 
> > > +VMWARE BALLOON DRIVER
> > > +M:	"VMware, Inc." <pv-drivers@vmware.com>
> > > +L:	linux-kernel@vger.kernel.org
> > > +S:	Maintained
> > > +F:	drivers/misc/vmw_balloon.c
> > 
> > I really hate having a "alias" as a maintainer, and not a "real" name.
> > Kernel development is done by individuals, we don't have companies as
> > authors or signed-off-by lines, we have developers.
> > 
> > So I will not accept this, sorry.  Please find a real person who is
> > willing to maintain this code, or just mark it unsupported.
> > 
> 
> OK, fair enough, we'll find a real name to attach here.

It's definitely better to have a person's name there but
there are many company exploders/aliases in MAINTAINERS.

There already is a pv-drivers@vmware.com too.

MAINTAINERS:M:  Adaptec OEM Raid Solutions <aacraid@adaptec.com>
MAINTAINERS:M:  dm-devel@redhat.com
MAINTAINERS:M:  Intel Linux Wireless <ilw@linux.intel.com>
MAINTAINERS:M:  Intel SCU Linux support <intel-linux-scu@intel.com>
MAINTAINERS:M:  iscsi-driver@qlogic.com
MAINTAINERS:M:  linux-driver@qlogic.com
MAINTAINERS:M:  Linux NICS <linux.nics@intel.com>
MAINTAINERS:M:  linux-wimax@intel.com
MAINTAINERS:M:  qla2xxx-upstream@qlogic.com
MAINTAINERS:M:  Solarflare linux maintainers <linux-net-drivers@solarflare.com>
MAINTAINERS:M:  support@lsi.com
MAINTAINERS:M:  Support Opensource <support.opensource@diasemi.com>
MAINTAINERS:M:  "VMware, Inc." <pv-drivers@vmware.com>


