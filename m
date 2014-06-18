Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaFRWDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:03:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaFRWDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:03:53 -0400
Date: Wed, 18 Jun 2014 15:07:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chase Southwood <chase.southwood@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: comedi: addi_apci_1564: remove send_sig()
 use
Message-ID: <20140618220752.GA26985@kroah.com>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
 <1401424913-21859-1-git-send-email-chase.southwood@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401424913-21859-1-git-send-email-chase.southwood@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:41:53PM -0500, Chase Southwood wrote:
> The addi-data drivers use send_sig() to let the user know when an
> interrupt has occurred. The "standard" way to do this in the comedi
> subsystem is to have a subdevice that supports asynchronous commands
> and use comedi_event() to signal the user.
> 
> Remove the send_sig() usage in this driver.
> 
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 23 ----------------------
>  1 file changed, 23 deletions(-)

This doesn't apply to my tree :(

Can you refresh this series based on the review comments for the later
patches and please resend?

thanks,

greg k-h
