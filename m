Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaFRWFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:05:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFRWFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:05:49 -0400
Date: Wed, 18 Jun 2014 15:09:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chase Southwood <chase.southwood@gmail.com>
Cc: devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] staging: comedi: addi_apci_1564: remove use of
 devpriv->b_OutputMemoryStatus
Message-ID: <20140618220947.GA27255@kroah.com>
References: <1401849124-21347-1-git-send-email-chase.southwood@gmail.com>
 <1401849217-21562-1-git-send-email-chase.southwood@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401849217-21562-1-git-send-email-chase.southwood@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:33:37PM -0500, Chase Southwood wrote:
> This member of the private data struct is only set at one location in the
> entire driver, and then never even used for anything.  Let's just remove
> its use.
> 
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeeten <hsweeten@visionengravers.com>
> ---
>  drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 5 -----
>  1 file changed, 5 deletions(-)

Ah, you did redo the series.  But this one still doesn't apply :(

Care to try again?

thanks,

greg k-h
