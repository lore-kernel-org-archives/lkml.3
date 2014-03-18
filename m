Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbaCRUbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:31:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbaCRUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:31:22 -0400
Date: Tue, 18 Mar 2014 13:33:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com
Subject: Re: [PATCH 0/3] usbip: move usbip out of staging
Message-ID: <20140318203324.GA25579@kroah.com>
References: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 10:11:20PM +0200, Valentina Manea wrote:
> After migrating userspace code to libudev, converting usbip-host
> to a device driver and various bug fixes and enhancements, USB/IP
> is fully functional and can be moved out of staging.
> 
> This patch series moves it as following:
> * userspace code to tools/usb/usbip
> * kernel code to drivers/usb/usbip
> 
> Besides this, a warning generated in the kernel code is solved.

Like Joe said, use -M please.

Also, I'm not going to be able to do this until after 3.15-rc1 is out,
due to changes to this code base in multiple trees.

So can you resend when -rc1 is out?

thanks,

greg k-h
