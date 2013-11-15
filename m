Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3KOV74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 16:59:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3KOV7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 16:59:48 -0500
Date: Sat, 16 Nov 2013 06:29:36 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        Johan Hedberg <johan.hedberg@intel.com>, Yu-Chen Cho <acho@suse.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH] Staging: btmtk_usb: Add hdev parameter to hdev->send
 driver callback
Message-ID: <20131115212936.GC14897@kroah.com>
References: <1384517231-1605-1-git-send-email-geert@linux-m68k.org>
 <D32EAC93-D2DE-431C-9DCB-885C5AA10A3A@holtmann.org>
 <20131115130820.GS5302@mwanda>
 <F615BA13-BEC1-457B-8002-BC6C149039EA@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F615BA13-BEC1-457B-8002-BC6C149039EA@holtmann.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 10:26:41PM +0900, Marcel Holtmann wrote:
> Hi Dan,
> 
> >> while this is patch is correct, I do not really care about staging drivers that actually bluntly violate my copyright.
> >> 
> > 
> > That's very cryptic.
> > 
> > What is going on here?  I googled it and I wasn't able to find what you
> > are talking about.  Care to give us a hint and what you want us to do
> > here?
> 
> the last time I checked, the majority of drivers/bluetooth/btusb.c has been written by myself. Now go and compare btusb.c to btmtk_usb.[ch].
> 
> > I have also added Johan Hedberg to the CC list because he also helped
> > break the build.  Don't do that.
> 
> Yes, we are doing exactly that. It is a staging driver. I could not care less if a staging drivers breaks the build or not.
> 
> If anybody cares about this driver, then take the time to merge it upstream. It has never been submitted to linux-bluetooth mailing list.
> 
> There are drivers that should have never been merged into staging.
> This is one of them. Look for yourself and explain to me why this
> driver is part of staging in the first place.

Because it was sent to me by a developer?

Seriously, what's the issue here, I didn't notice it was a fork of your
code, sorry, I didn't check.  I figured it would be eventually cleaned
up properly and then it will be sent to linux-bluetooth for proper
merging.

Yu-Chen, what's the satus of getting this cleaned up "properly"?  You
haven't really done anything on this since I took the driver in May.

thanks,

greg k-h
