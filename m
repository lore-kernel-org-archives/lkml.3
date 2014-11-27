Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaK0P5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:57:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaK0P5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:57:01 -0500
Date: Thu, 27 Nov 2014 07:55:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging:drivers:rtl8712:drv_types.h: Added blank line
 after declarations
Message-ID: <20141127155539.GA24149@kroah.com>
References: <1417102203-7093-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417102203-7093-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 09:00:03PM +0530, Anjana Sasindran wrote:
>         This patch fixes the two checkpatch.pl warnings:
> 
>         WARNING:Missing a blank line after declaration
> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/staging/rtl8712/drv_types.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
> index 3d0a98b..3d8abfa 100644
> --- a/drivers/staging/rtl8712/drv_types.h
> +++ b/drivers/staging/rtl8712/drv_types.h
> @@ -1,4 +1,4 @@
> -/******************************************************************************
> +0/******************************************************************************
>   *
>   * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
>   *

You obviously did not compile this change :(
