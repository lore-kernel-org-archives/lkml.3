Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3GYFIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 01:08:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3GYFIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 01:08:52 -0400
Date: Wed, 24 Jul 2013 22:10:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: kys@microsoft.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: hv: remove HV_DRV_VERSION
Message-ID: <20130725051004.GA21893@kroah.com>
References: <1369819747-6218-1-git-send-email-olaf@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369819747-6218-1-git-send-email-olaf@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 11:29:07AM +0200, Olaf Hering wrote:
> Remove HV_DRV_VERSION, it has no meaning for upstream drivers.
> 
> Initially it was supposed to show the "Linux Integration Services"
> version, now it is not in sync anymore with the out-of-tree drivers
> available from the MSFT website.
> 
> The only place where a version string is still required is the KVP
> command "IntegrationServicesVersion" which is handled by
> tools/hv/hv_kvp_daemon.c. To satisfy such KVP request from the host pass
> the current string to the daemon during KVP userland registration.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> ---
>  drivers/hid/hid-hyperv.c        |  1 -
>  drivers/hv/hv_balloon.c         |  1 -
>  drivers/hv/hv_kvp.c             |  2 ++
>  drivers/hv/hv_util.c            |  1 -
>  drivers/hv/vmbus_drv.c          |  1 -
>  drivers/net/hyperv/netvsc_drv.c |  2 --
>  drivers/scsi/storvsc_drv.c      |  1 -
>  drivers/video/hyperv_fb.c       |  1 -
>  include/linux/hyperv.h          | 21 ---------------------
>  9 files changed, 2 insertions(+), 29 deletions(-)

KY, what happened to this patch?  Any ack/nak for it?

thanks,

greg k-h
