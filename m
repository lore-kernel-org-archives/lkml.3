Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3GXWuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:50:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3GXWuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:50:04 -0400
Date: Wed, 24 Jul 2013 15:50:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb,uhci: add a new tag for virtual uhci devices
Message-ID: <20130724225003.GB1639@kroah.com>
References: <1372228185-11518-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372228185-11518-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:29:45PM +0800, Li, Zhen-Hua wrote:
> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
> 
> There's another patch trying to fix this warning:
>  "Controller not stopped yet!". 
> It is : 997ff893603c6455da4c5e26ba1d0f81adfecdfc .
> 
> I don't think it is appropriate to avoid auto-stop for all HP uhci
> devices. So add one  tag for the virtual uhci devices, it is used
> to replace "wait_for_hp" in the auto-stop case.
> 
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>  drivers/usb/host/uhci-hcd.h |    1 +
>  drivers/usb/host/uhci-hub.c |    2 +-
>  drivers/usb/host/uhci-pci.c |   21 +++++++++++++++++++++
>  3 files changed, 23 insertions(+), 1 deletion(-)

Not applied due to massive confusion in this thread, sorry.

Please resend once you all work it out...

greg k-h
