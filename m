Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaCFGRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:17:25 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:44206 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaCFGRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:17:24 -0500
MIME-Version: 1.0
In-Reply-To: <20140305101541.GZ26722@mwanda>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
	<1393960252-21247-2-git-send-email-valentina.manea.m@gmail.com>
	<20140305094259.GX26722@mwanda>
	<20140305101541.GZ26722@mwanda>
Date: Thu, 6 Mar 2014 08:17:23 +0200
Message-ID: <CABdoFFctkncw3SWJB1P32AMNKQZUACwhB3SM2W9Kkm5Fh_4M3A@mail.gmail.com>
Subject: Re: [PATCH 01/12] staging: usbip: userspace: migrate usbip_bind to libudev
From: Valentina Manea <valentina.manea.m@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        ly80toro@cip.cs.fau.de, tobias.polzer@fau.de,
        linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        dominik.paulus@fau.de, ihadzic@research.bell-labs.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 12:15 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Wed, Mar 05, 2014 at 12:42:59PM +0300, Dan Carpenter wrote:
>> On Tue, Mar 04, 2014 at 09:10:41PM +0200, Valentina Manea wrote:
>> > diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
>> > index 2cb81b3..565ac78 100644
>> > --- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
>> > +++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
>> > @@ -29,6 +29,15 @@
>> >  #define USBIP_HOST_DRV_NAME        "usbip-host"
>> >  #define USBIP_VHCI_DRV_NAME        "vhci_hcd"
>> >
>> > +/* sysfs constants */
>> > +#define SYSFS_MNT_PATH         "/sys"
>> > +#define SYSFS_BUS_NAME         "bus"
>> > +#define SYSFS_BUS_TYPE         "usb"
>> > +#define SYSFS_DRIVERS_NAME     "drivers"
>>
>> What on earth???  I don't even want to review any further than this.
>>
>> Groan....  No.  no no no no no.
>>
>
> I overreacted.  This stuff was already in the original code, and this
> change just moves it around.
>
> Fine fine.  These patch set seem ok with me.
>
> regards,
> dan carpenter
>
>

Indeed, there are improvements than can be made to the code but
I figured doing them all in just one patch series would be a step too big.
This should be work for future patches.

Thanks for your feedback.

Valentina
