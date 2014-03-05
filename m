Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaCEKSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:18:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32692 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbaCEKRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:17:05 -0500
Date: Wed, 5 Mar 2014 13:15:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        ly80toro@cip.cs.fau.de, tobias.polzer@fau.de,
        linux-kernel@vger.kernel.org, firefly@lists.rosedu.org,
        dominik.paulus@fau.de, ihadzic@research.bell-labs.com
Subject: Re: [PATCH 01/12] staging: usbip: userspace: migrate usbip_bind to
 libudev
Message-ID: <20140305101541.GZ26722@mwanda>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
 <1393960252-21247-2-git-send-email-valentina.manea.m@gmail.com>
 <20140305094259.GX26722@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305094259.GX26722@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 12:42:59PM +0300, Dan Carpenter wrote:
> On Tue, Mar 04, 2014 at 09:10:41PM +0200, Valentina Manea wrote:
> > diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
> > index 2cb81b3..565ac78 100644
> > --- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
> > +++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
> > @@ -29,6 +29,15 @@
> >  #define USBIP_HOST_DRV_NAME	"usbip-host"
> >  #define USBIP_VHCI_DRV_NAME	"vhci_hcd"
> >  
> > +/* sysfs constants */
> > +#define SYSFS_MNT_PATH         "/sys"
> > +#define SYSFS_BUS_NAME         "bus"
> > +#define SYSFS_BUS_TYPE         "usb"
> > +#define SYSFS_DRIVERS_NAME     "drivers"
> 
> What on earth???  I don't even want to review any further than this.
> 
> Groan....  No.  no no no no no.
> 

I overreacted.  This stuff was already in the original code, and this
change just moves it around.

Fine fine.  These patch set seem ok with me.

regards,
dan carpenter


