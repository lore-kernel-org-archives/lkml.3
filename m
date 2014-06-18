Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaFRXT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:19:27 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:46459 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbaFRXT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:19:26 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com
Subject: Re: [PATCH] MAINTAINERS: add entry for VMware Balloon driver
Date: Wed, 18 Jun 2014 16:19:15 -0700
Message-ID: <4389061.FeVMqoJiMc@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.12.5 (Linux/3.14.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140618231742.GB7234@kroah.com>
References: <1403132941-1394-1-git-send-email-dtor@vmware.com> <20140618231742.GB7234@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 18, 2014 04:17:42 PM Greg Kroah-Hartman wrote:
> On Wed, Jun 18, 2014 at 04:09:01PM -0700, Dmitry Torokhov wrote:
> > Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> > ---
> > 
> >  MAINTAINERS                |    6 ++++++
> >  drivers/misc/vmw_balloon.c |    2 +-
> >  2 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 6c484ac..3a446e8 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9645,6 +9645,12 @@ L:	virtualization@lists.linux-foundation.org
> > 
> >  S:	Supported
> >  F:	arch/x86/kernel/cpu/vmware.c
> > 
> > +VMWARE BALLOON DRIVER
> > +M:	"VMware, Inc." <pv-drivers@vmware.com>
> > +L:	linux-kernel@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/misc/vmw_balloon.c
> 
> I really hate having a "alias" as a maintainer, and not a "real" name.
> Kernel development is done by individuals, we don't have companies as
> authors or signed-off-by lines, we have developers.
> 
> So I will not accept this, sorry.  Please find a real person who is
> willing to maintain this code, or just mark it unsupported.
> 

OK, fair enough, we'll find a real name to attach here.

Thanks,
Dmitry
