Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbbAIX1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:27:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbbAIX1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:27:13 -0500
Date: Fri, 9 Jan 2015 15:27:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Cc: hjk@hansjkoch.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: uio: Simplify the lifetime logic of struct
 uio_device.
Message-ID: <20150109232712.GA1878@kroah.com>
References: <1418759544-2610-1-git-send-email-mandeep.sandhu@cyaninc.com>
 <1418759544-2610-2-git-send-email-mandeep.sandhu@cyaninc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418759544-2610-2-git-send-email-mandeep.sandhu@cyaninc.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:52:21AM -0800, Mandeep Sandhu wrote:
> Embed struct device into struct uio_device, and use
> the refcounting and the release method of struct device
> to control struct uio_device.
> 
> This allows device_create and device_destroy to be replaced
> with the more standard device_register and device_unregister,
> and allows the struct device reference count to act as a
> reference count on struct idev as well.
> 
> Tested-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
> Signed-off-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
> ---
>  drivers/uio/uio.c          | 41 ++++++++++++++++++++++++++---------------
>  include/linux/uio_driver.h |  3 ++-
>  2 files changed, 28 insertions(+), 16 deletions(-)

The subject makes no sense, this has nothing to do with the staging tree
:(

Please fix up and resend this series.

thanks,

greg k-h
