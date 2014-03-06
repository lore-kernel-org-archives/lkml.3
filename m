Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaCFSVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:21:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25912 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaCFSVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:21:06 -0500
Date: Thu, 6 Mar 2014 21:19:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Valentina Manea <valentina.manea.m@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        ly80toro@cip.cs.fau.de, tobias.polzer@fau.de,
        linux-kernel@vger.kernel.org, firefly@lists.rosedu.org,
        dominik.paulus@fau.de, ihadzic@research.bell-labs.com
Subject: Re: [PATCH 01/12] staging: usbip: userspace: migrate usbip_bind to
 libudev
Message-ID: <20140306181936.GI26722@mwanda>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
 <1393960252-21247-2-git-send-email-valentina.manea.m@gmail.com>
 <53189F05.8000608@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53189F05.8000608@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 09:15:01AM -0700, Shuah Khan wrote:
> >--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
> >+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
> >@@ -29,6 +29,15 @@
> >  #define USBIP_HOST_DRV_NAME	"usbip-host"
> >  #define USBIP_VHCI_DRV_NAME	"vhci_hcd"
> >
> >+/* sysfs constants */
> >+#define SYSFS_MNT_PATH         "/sys"
> >+#define SYSFS_BUS_NAME         "bus"
> >+#define SYSFS_BUS_TYPE         "usb"
> >+#define SYSFS_DRIVERS_NAME     "drivers"
> >+
> >+#define SYSFS_PATH_MAX		256
> >+#define SYSFS_BUS_ID_SIZE	32
> 
> I wish we have some global defines we could use.

Except for the mount point, the rest of the path is part of the kernel
API.

regards,
dan carpenter

