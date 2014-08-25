Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbaHYRoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:44:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbaHYRoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:44:22 -0400
Date: Mon, 25 Aug 2014 10:43:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com, max@vozeler.com,
        shuahkhan@gmail.com
Subject: Re: [PATCH 0/4] *** SUBJECT HERE ***
Message-ID: <20140825174341.GA19993@kroah.com>
References: <1408509062-1375-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408509062-1375-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 07:30:58AM +0300, Valentina Manea wrote:
> After migrating userspace code to libudev, converting usbip-host
> to a device driver and various bug fixes and enhancements, USB/IP
> is fully functional and can be moved out of staging.
> 
> This patch series moves it as following:
> * userspace code to tools/usb/usbip
> * kernel code to drivers/usb/usbip
> 
> A warning generated in the kernel code is also solved and an entry
> in MAINTAINERS file is created for this driver.

Looks good, all now queued up, thanks.

greg k-h
