Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab3GEVnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:43:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3GEVnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:43:19 -0400
Date: Fri, 5 Jul 2013 14:43:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why no USB id list in the kernel sources?
Message-ID: <20130705214318.GA20918@kroah.com>
References: <51D73BCD.1030401@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D73BCD.1030401@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:34:05PM +0200, Michael Opdenacker wrote:
> Hi,
> 
> I'm wondering why there is no include/linux/usb_ids.h (or
> include/linux/usb/ids.h) file in the same way there is a
> include/linux/pci_ids.h for PCI.

Because that way lies madness, we have learned from our mistakes and do
not want to repeat them again :)

It turns out that the pci_ids file isn't a good idea, it's a merge mess,
and only really works when you have ids that are shared across different
drivers.  In the end, that is a very small number, and it's just not
worth the time and effort to do this in a centralized way.

Hope this helps explain things, if you want more details, dig into the
linux usb mailing list about 10-15 years ago when this decision was
made.

thanks,

greg k-h
