Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3IZUPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:15:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3IZUOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:14:55 -0400
Date: Thu, 26 Sep 2013 13:14:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: add support for Merrifield
Message-ID: <20130926201454.GC16369@kroah.com>
References: <1380225704-28923-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380225704-28923-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 01:01:44PM -0700, David Cohen wrote:
> Add PCI id for Intel Merrifield
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/usb/dwc3/dwc3-pci.c | 2 ++
>  1 file changed, 2 insertions(+)

Nice, Felipe, mind if I just pick this up now, as I'm applying USB
patches at the moment...

David, this should go to older kernels as well, right?

thanks,

greg k-h
