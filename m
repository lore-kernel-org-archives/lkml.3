Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaFDPvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:51:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaFDPvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:51:15 -0400
Date: Wed, 4 Jun 2014 08:54:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, haver@linux.vnet.ibm.com
Subject: Re: [PATCH 4/4] GenWQE: Increase driver version number
Message-ID: <20140604155454.GA2866@kroah.com>
References: <1401890273-13067-1-git-send-email-klebers@linux.vnet.ibm.com>
 <1401890273-13067-5-git-send-email-klebers@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401890273-13067-5-git-send-email-klebers@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:57:53AM -0300, Kleber Sacilotto de Souza wrote:
> Increase genwqe driver version number.
> 
> Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
> ---
>  drivers/misc/genwqe/genwqe_driver.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/genwqe/genwqe_driver.h b/drivers/misc/genwqe/genwqe_driver.h
> index cd52631..a506e9a 100644
> --- a/drivers/misc/genwqe/genwqe_driver.h
> +++ b/drivers/misc/genwqe/genwqe_driver.h
> @@ -36,7 +36,7 @@
>  #include <asm/byteorder.h>
>  #include <linux/genwqe/genwqe_card.h>
>  
> -#define DRV_VERS_STRING		"2.0.15"
> +#define DRV_VERS_STRING		"2.0.21"

Why is this even needed?  Can't you go off of the kernel version number
now?  Who needs / wants this number?

thanks,

greg k-h
