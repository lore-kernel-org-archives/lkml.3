Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3K0Knx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:43:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28452 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab3K0Kns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:43:48 -0500
Date: Wed, 27 Nov 2013 13:43:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rkuo <rkuo@codeaurora.org>, hans.verkuil@cisco.com,
        Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
        m.chehab@samsung.com
Subject: Re: [PATCH v2] drivers: staging: media: go7007: go7007-usb.c use
 pr_*() instead of dev_*() before 'go' initialized in go7007_usb_probe()
Message-ID: <20131127104325.GE28413@mwanda>
References: <20131125011938.GB18921@codeaurora.org>
 <5292B845.3010404@gmail.com>
 <5292B8A0.7020409@gmail.com>
 <5294255E.7040105@gmail.com>
 <52956442.50001@gmail.com>
 <1385522475.18487.34.camel@joe-AO722>
 <529569A5.1020008@gmail.com>
 <52956B78.6050107@gmail.com>
 <20131127040338.GB23930@kroah.com>
 <529573F6.9080106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529573F6.9080106@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 12:24:22PM +0800, Chen Gang wrote:
> On 11/27/2013 12:03 PM, Greg KH wrote:
> > On Wed, Nov 27, 2013 at 11:48:08AM +0800, Chen Gang wrote:
> >> dev_*() assumes 'go' is already initialized, so need use pr_*() instead
> >> of before 'go' initialized. Related warning (with allmodconfig under
> >> hexagon):
> >>
> >>     CC [M]  drivers/staging/media/go7007/go7007-usb.o
> >>   drivers/staging/media/go7007/go7007-usb.c: In function 'go7007_usb_probe':
> >>   drivers/staging/media/go7007/go7007-usb.c:1060:2: warning: 'go' may be used uninitialized in this function [-Wuninitialized]
> >>
> >> Also remove useless code after 'return' statement.
> > 
> > This should all be fixed in my staging-linus branch already, right?  No
> > need for this anymore from what I can tell, sorry.
> > 
> 
> That's all right (in fact don't need sorry).  :-)
> 
> And excuse me, I am not quite familiar upstream kernel version merging
> and branches. Is it still better/suitable/possible to sync some bug fix
> patches from staging brach to next brach?

next syncs with everyone once a day.

regards,
dan carpenter

