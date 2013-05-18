Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3ERVKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 17:10:00 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:42230 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3ERVJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 17:09:59 -0400
Date: Sat, 18 May 2013 23:09:48 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Petko Manolov <petkan@nucleusys.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers: net: usb: rtl8150: bug fixing and cleanup
Message-ID: <20130518210948.GA26590@electric-eye.fr.zoreil.com>
References: <alpine.DEB.2.02.1305181902080.7518@fry.nucleusys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305181902080.7518@fry.nucleusys.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petko Manolov <petkan@nucleusys.com> :
> From: Petko Manolov <petkan@nucleusys.com>
> 
> Moving constant and structure definitions out of rtl8150.c;

What's the point ?

[...]
> ---
>  drivers/net/usb/rtl8150.c |  121 +----------------------------------
>  1 file changed, 2 insertions(+), 119 deletions(-)
> 
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> index a491d3a..7d1897b 100644
> --- a/drivers/net/usb/rtl8150.c
> +++ b/drivers/net/usb/rtl8150.c
> @@ -17,132 +17,15 @@
>  #include <linux/usb.h>
>  #include <asm/uaccess.h>
>  
> +#include "rtl8150.h"

It won't compile. You shouldn't do that.

-- 
Ueimor
