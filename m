Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaHDSgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:36:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaHDSgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:36:51 -0400
Date: Mon, 4 Aug 2014 11:36:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        sboyd@codeaurora.org, jslaby@suse.cz, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm: fix checkpatch warnings
Message-ID: <20140804183650.GB19594@kroah.com>
References: <1407162046-29729-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407162046-29729-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 07:50:46PM +0530, Kiran Padwal wrote:
> This patch fixes the following checkpatch.pl warning:
> 
> WARNING: braces {} are not necessary for any arm of this statement
> 
> WARNING: Missing a blank line after declarations
> 
> WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> 
> WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> 
> WARNING: else is not generally useful after a break or return
> 
> WARNING: void function return statements are not generally useful
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/tty/serial/msm_serial.c |   26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)

That's a lot of different things all mushed into one patch.  Please
break this up into "one change per patch" so we can review it better.

thanks,

greg k-h
