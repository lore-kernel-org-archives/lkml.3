Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3FQUjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:39:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3FQUju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:39:50 -0400
Date: Mon, 17 Jun 2013 13:39:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yuan-Hsin Chen <yhchen@faraday-tech.com>
Cc: stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com, balbi@ti.com,
        florian@openwrt.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanlmm@gmail.com,
        ratbert.chuang@gmail.com, john453@faraday-tech.com
Subject: Re: [PATCH] usb: host: Faraday fotg210-hcd driver
Message-ID: <20130617203948.GA32731@kroah.com>
References: <1370452543-19014-1-git-send-email-yhchen@faraday-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370452543-19014-1-git-send-email-yhchen@faraday-tech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 05:15:43PM +0000, Yuan-Hsin Chen wrote:
> FOTG210 is an OTG controller which can be configured as an
> USB2.0 host. FOTG210 host is an ehci-like controller with
> some differences. First, register layout of FOTG210 is
> incompatible with EHCI. Furthermore, FOTG210 is lack of
> siTDs which means iTDs are used for both HS and FS ISO
> transfer.
> 
> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
> ---
>  drivers/usb/Makefile           |    1 +
>  drivers/usb/host/Kconfig       |   12 +
>  drivers/usb/host/Makefile      |    1 +
>  drivers/usb/host/fotg210-hcd.c | 5967 ++++++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/fotg210.h     |  746 +++++
>  5 files changed, 6727 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/host/fotg210-hcd.c
>  create mode 100644 drivers/usb/host/fotg210.h

You obviously didn't even run this through checkpatch.pl, did you?

$ ./scripts/checkpatch.pl --terse ../usb.mbox | tail -n 1
total: 138 errors, 618 warnings, 6742 lines checked

Please fix all of these if you wish us to at least start reviewing the
patch.  Your internal Q/A should have caught this first, please be more
careful in the future.

thanks,

greg k-h
