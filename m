Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaFRXpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:45:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaFRXpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:45:35 -0400
Date: Wed, 18 Jun 2014 16:49:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH] MAINTAINERS: add entry for VMware Balloon driver
Message-ID: <20140618234934.GA9378@kroah.com>
References: <1403132941-1394-1-git-send-email-dtor@vmware.com>
 <20140618231742.GB7234@kroah.com>
 <4389061.FeVMqoJiMc@dtor-d630.eng.vmware.com>
 <1403134100.14018.8.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403134100.14018.8.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 04:28:20PM -0700, Joe Perches wrote:
> On Wed, 2014-06-18 at 16:19 -0700, Dmitry Torokhov wrote:
> > On Wednesday, June 18, 2014 04:17:42 PM Greg Kroah-Hartman wrote:
> > > On Wed, Jun 18, 2014 at 04:09:01PM -0700, Dmitry Torokhov wrote:
> > > > Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> > > > ---
> > > > 
> > > >  MAINTAINERS                |    6 ++++++
> > > >  drivers/misc/vmw_balloon.c |    2 +-
> > > >  2 files changed, 7 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index 6c484ac..3a446e8 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -9645,6 +9645,12 @@ L:	virtualization@lists.linux-foundation.org
> > > > 
> > > >  S:	Supported
> > > >  F:	arch/x86/kernel/cpu/vmware.c
> > > > 
> > > > +VMWARE BALLOON DRIVER
> > > > +M:	"VMware, Inc." <pv-drivers@vmware.com>
> > > > +L:	linux-kernel@vger.kernel.org
> > > > +S:	Maintained
> > > > +F:	drivers/misc/vmw_balloon.c
> > > 
> > > I really hate having a "alias" as a maintainer, and not a "real" name.
> > > Kernel development is done by individuals, we don't have companies as
> > > authors or signed-off-by lines, we have developers.
> > > 
> > > So I will not accept this, sorry.  Please find a real person who is
> > > willing to maintain this code, or just mark it unsupported.
> > > 
> > 
> > OK, fair enough, we'll find a real name to attach here.
> 
> It's definitely better to have a person's name there but
> there are many company exploders/aliases in MAINTAINERS.
> 
> There already is a pv-drivers@vmware.com too.
> 
> MAINTAINERS:M:  Adaptec OEM Raid Solutions <aacraid@adaptec.com>
> MAINTAINERS:M:  dm-devel@redhat.com
> MAINTAINERS:M:  Intel Linux Wireless <ilw@linux.intel.com>
> MAINTAINERS:M:  Intel SCU Linux support <intel-linux-scu@intel.com>
> MAINTAINERS:M:  iscsi-driver@qlogic.com
> MAINTAINERS:M:  linux-driver@qlogic.com
> MAINTAINERS:M:  Linux NICS <linux.nics@intel.com>
> MAINTAINERS:M:  linux-wimax@intel.com
> MAINTAINERS:M:  qla2xxx-upstream@qlogic.com
> MAINTAINERS:M:  Solarflare linux maintainers <linux-net-drivers@solarflare.com>
> MAINTAINERS:M:  support@lsi.com
> MAINTAINERS:M:  Support Opensource <support.opensource@diasemi.com>
> MAINTAINERS:M:  "VMware, Inc." <pv-drivers@vmware.com>

Yeah, and in every case I've ever had to deal with one, it's never
worked.  People are maintainers, not email aliases.

greg k-h
