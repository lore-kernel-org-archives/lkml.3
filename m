Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175AbaEQTXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 15:23:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25130 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaEQTXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 15:23:36 -0400
Date: Sat, 17 May 2014 22:22:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Martin Kepplinger <martink@posteo.de>, gregkh@linuxfoundation.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCHv2] staging: media: as102: replace custom dprintk() with
 dev_dbg()
Message-ID: <20140517192253.GC15585@mwanda>
References: <53776B57.5050504@iki.fi>
 <1400342738-32652-1-git-send-email-martink@posteo.de>
 <53779A7F.8020007@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53779A7F.8020007@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 08:21:03PM +0300, Antti Palosaari wrote:
> On 05/17/2014 07:05 PM, Martin Kepplinger wrote:
> >don't reinvent dev_dbg(). remove dprintk() in as102_drv.c.
> >use the common kernel coding style.
> >
> >Signed-off-by: Martin Kepplinger <martink@posteo.de>
> 
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> 
> >---
> >this applies to next-20140516. any more suggestions?
> >more cleanup can be done when dprintk() is completely gone.
> 
> Do you have the device? I am a bit reluctant patching that driver
> without any testing as it has happened too many times something has
> gone totally broken.

Looking through the log the only time I see breakage is build breakage
on allyesconfig.

1ec9a35 [media] staging: as102: Add missing function argument

This was a compile warning and it definitely should have been caught
before the code was submitted or merged, but it wasn't something people
would hit in real life.

regards,
dan carpenter
