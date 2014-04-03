Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaDCSH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:07:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45117 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaDCSHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:07:54 -0400
Date: Thu, 3 Apr 2014 14:07:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH] Fixes to Linux v3.13 - bugs.xenproject.org ones. (v1).
Message-ID: <20140403180739.GB4410@localhost.localdomain>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
 <533D4D04.2010101@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533D4D04.2010101@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 12:59:00PM +0100, David Vrabel wrote:
> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> > Hey,
> > 
> > Two of these:
> >  [PATCH 2/4] xen/manage: Poweroff forcefully if user-space is not yet
> >  [PATCH 4/4] xen/xenbus: Avoid synchronous wait on XenBus stalling
> > 
> > fix the bugs.xenproject.org outstanding bugs.
> > 
> > The other ones are that were discovered on xen-devel and discussed.
> > They should go in v3.13 and as the merge window is next week I am
> > hoping they can be squeezed in then.
> > 
> > 
> >  drivers/xen/manage.c            | 64 ++++++++++++++++++++++++++++++++++-------
> >  drivers/xen/pci.c               | 47 ++++++++++++++++++++++++++++++
> >  drivers/xen/xenbus/xenbus_xs.c  | 24 ++++++++++++++--
> >  include/xen/interface/physdev.h | 11 +++++++
> >  
> > Konrad Rzeszutek Wilk (4):
> >       xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG areas.
> >       xen/manage: Poweroff forcefully if user-space is not yet up.
> >       xen/manage: Guard against user-space initiated poweroff and XenBus.
> >       xen/xenbus: Avoid synchronous wait on XenBus stalling shutdown/restart.
> 
> Konrad, can you repost a final series please?  I'm not 100% which
> patches should be applied.

Sure thing. Will do that on tomorrow.
> 
> David
