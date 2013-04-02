Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab3DBXEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:04:41 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:45928 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629Ab3DBXEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:04:38 -0400
Date: Tue, 2 Apr 2013 16:04:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130402230435.GA9462@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <515B51F7.6070901@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515B51F7.6070901@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 02:47:35PM -0700, Randy Dunlap wrote:
> On 04/02/13 15:15, Jacob Pan wrote:
> > diff --git a/drivers/platform/x86/intel_rapl.c b/drivers/platform/x86/intel_rapl.c
> > new file mode 100644
> > index 0000000..56ee928
> > --- /dev/null
> > +++ b/drivers/platform/x86/intel_rapl.c
> > @@ -0,0 +1,1323 @@
> > +/*
> > + *  intel_rapl.c - Intel Running Average Power Limit Driver for MSR based
> > + *                 RAPL interface
> > + *
> > + *  Copyright (c) 2013, Intel Corporation.
> > + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +#include <linux/sysfs.h>
> > +
> 
> > +#include "../../../fs/sysfs/sysfs.h"
> 
> 
> What does this driver need from ^^^^^^ that file, which says:
> 
>  * fs/sysfs/sysfs.h - sysfs internal header file
> 
> and should that be moved to include/linux/sysfs.h ?

See my other complain about this already, I beat you to it :)

greg k-h
