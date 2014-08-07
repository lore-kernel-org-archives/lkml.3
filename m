Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbaHGFeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:34:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaHGFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:34:16 -0400
Date: Wed, 6 Aug 2014 22:33:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com, max@vozeler.com
Subject: Re: [PATCH 0/3] usbip: move usbip out of staging
Message-ID: <20140807053344.GA5754@kroah.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 08:10:25AM +0300, Valentina Manea wrote:
> This is a resend of the patch series from March.
> 
> After migrating userspace code to libudev, converting usbip-host
> to a device driver and various bug fixes and enhancements, USB/IP
> is fully functional and can be moved out of staging.
> 
> This patch series moves it as following:
> * userspace code to tools/usb/usbip
> * kernel code to drivers/usb/usbip
> 
> Besides this, a warning generated in the kernel code is solved.

What kernel version is this against?

And can we get a maintainer for this code?  I don't want to see it sit
"ownerless" in the kernel tree.  Will you be willing to do this?

thanks,

greg k-h
