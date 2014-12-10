Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbaLJOUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:20:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbaLJOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:20:06 -0500
Date: Wed, 10 Dec 2014 09:20:03 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: rts5208: Removed the new typedefs
Message-ID: <20141210142003.GA15524@kroah.com>
References: <1418219656-2964-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418219656-2964-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 07:24:16PM +0530, Anjana Sasindran wrote:
> This patch fix the checkpatch.pl warning:
> 
> WARNING: do not add new typedefs
> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/staging/rts5208/rtsx_sys.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rts5208/rtsx_sys.h b/drivers/staging/rts5208/rtsx_sys.h
> index 0b6b4d4..f04d997 100644
> --- a/drivers/staging/rts5208/rtsx_sys.h
> +++ b/drivers/staging/rts5208/rtsx_sys.h
> @@ -28,7 +28,7 @@
>  #include "rtsx_chip.h"
>  #include "rtsx_card.h"
>  
> -typedef dma_addr_t ULONG_PTR;
> +dma_addr_t ULONG_PTR;
>  
>  static inline void rtsx_exclusive_enter_ss(struct rtsx_chip *chip)
>  {

Please learn how the C language works before attempting to contribute to
the Linux kernel.  You obviously didn't even test build this code, which
means you are trying to waste my time, a very rude thing to do to
someone else, don't you think?

*plonk*
