Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3GYFt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 01:49:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3GYFt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 01:49:28 -0400
Date: Wed, 24 Jul 2013 22:50:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 2/3] mei: don't get stack in select during reset
Message-ID: <20130725055040.GA16787@kroah.com>
References: <1374672179-23949-1-git-send-email-tomas.winkler@intel.com>
 <1374672179-23949-3-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374672179-23949-3-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 04:22:58PM +0300, Tomas Winkler wrote:
> Clear pending connection after hw reset but before hw start
> and wake up the waiting task in poll. Signal POLLERR in select
> when device went through reset.
> 
> Add wrapper mei_cl_is_connected for checking if
> the device and client are connected.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/amthif.c | 14 +++++++++++---
>  drivers/misc/mei/client.c |  5 +----
>  drivers/misc/mei/client.h |  7 +++++++
>  drivers/misc/mei/init.c   | 13 ++++++++-----
>  drivers/misc/mei/main.c   | 22 +++++++++++++++-------
>  5 files changed, 42 insertions(+), 19 deletions(-)

This patch fails to apply, can you refresh it and resend?

thanks,

greg k-h
