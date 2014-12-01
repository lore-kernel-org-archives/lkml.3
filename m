Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaLANG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:06:29 -0500
Received: from aer-iport-4.cisco.com ([173.38.203.54]:17847 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaLANG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:06:28 -0500
X-IronPort-AV: E=Sophos;i="5.07,493,1413244800"; 
   d="scan'208";a="252458701"
Message-ID: <547C67C5.500@cisco.com>
Date: Mon, 01 Dec 2014 14:06:13 +0100
From: Hans Verkuil <hansverk@cisco.com>
Organization: Cisco Systems Norway
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: anjana s <anjanasasindran123@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg KH <gregkh@linuxfoundation.org>, joe@perches.com,
        m.chehab@samsung.com, hans.verkuil@cisco.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:media:omap24xx:v4l2-int-device.h: Added
 a '*' before ')'--(parenthesis closing)
References: <1417345082-3526-1-git-send-email-anjanasasindran123@gmail.com>	<20141201085008.GC4994@mwanda> <CABU2W3oMGH9v0+mjw+s+nRpbOj7pxdVvdMWhnmNgEwKPJ2VSmg@mail.gmail.com>
In-Reply-To: <CABU2W3oMGH9v0+mjw+s+nRpbOj7pxdVvdMWhnmNgEwKPJ2VSmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: hansverk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 02:01 PM, anjana s wrote:
>  Should I do anything on this further?

No. The driver will disappear in 3.19, so there is no point to this patch.

BTW, always check the Kconfig to see if a staging driver is marked deprecated.
If so, then patches are pointless.

Regards,

	Hans

> Looking forward to hear from you.
> 
> On Mon, Dec 1, 2014 at 2:20 PM, Dan Carpenter <dan.carpenter@oracle.com <mailto:dan.carpenter@oracle.com>> wrote:
> 
>     On Sun, Nov 30, 2014 at 04:28:02PM +0530, Anjana Sasindran wrote:
>     > This patch fix a checkpatch.pl <http://checkpatch.pl> error:
>     >
>     > ERROR: space prohibited before ')' parenthesis closing
>     >
>     > Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com <mailto:anjanasasindran123@gmail.com>>
>     > ---
>     >  drivers/staging/media/omap24xx/v4l2-int-device.h | 2 +-
>     >  1 file changed, 1 insertion(+), 1 deletion(-)
>     >
>     > diff --git a/drivers/staging/media/omap24xx/v4l2-int-device.h b/drivers/staging/media/omap24xx/v4l2-int-device.h
>     > index 0286c95..9490595 100644
>     > --- a/drivers/staging/media/omap24xx/v4l2-int-device.h
>     > +++ b/drivers/staging/media/omap24xx/v4l2-int-device.h
>     > @@ -292,7 +292,7 @@ V4L2_INT_WRAPPER_1(s_video_routing, struct v4l2_routing, *);
>     >
>     >  V4L2_INT_WRAPPER_0(dev_init);
>     >  V4L2_INT_WRAPPER_0(dev_exit);
>     > -V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );
>     > +V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, *);
> 
>     Wait, what?  The changelog for this is not clear.  This looks like
>     either a bug fix or a bug introducer.
> 
>     This driver has been deleted in linux-next anyway so I guess it doesn't
>     matter.  Please work against linux-next.
> 
>     regards,
>     dan carpenter
> 
> 
> 
> 
> -- 
> Anjana S
> Amrita School of Engineering
> anjanasasindran123@gmail.com <mailto:anjanasasindran123@gmail.com>
> 
> 
> 

