Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbaAHXPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:15:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109AbaAHXO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:14:59 -0500
Date: Wed, 8 Jan 2014 15:15:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140108231529.GA23632@kroah.com>
References: <1389224915-8737-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389224915-8737-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 03:48:35PM -0800, K. Y. Srinivasan wrote:
> Implement the file copy service for Linux guests on Hyper-V. This permits the
> host to copy a file (over VMBUS) into the guest. This facility is part of
> "guest integration services" supported on the Windows platform.
> Here is a link that provides additional details on this functionality:
> 
> http://technet.microsoft.com/en-us/library/dn464282.aspx
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/Makefile        |    2 +-
>  drivers/hv/hv_fcopy.c      |  451 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/hv/hv_util.c       |   10 +
>  include/linux/hyperv.h     |   60 ++++++
>  tools/hv/hv_fcopy_daemon.c |  171 +++++++++++++++++
>  5 files changed, 693 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/hv/hv_fcopy.c
>  create mode 100644 tools/hv/hv_fcopy_daemon.c

It's too late in the 3.14 development cycle for this (i.e. 3.13 is going
to be out this weekend), but I'll queue this up for 3.15-rc1.

thanks,

greg k-h
