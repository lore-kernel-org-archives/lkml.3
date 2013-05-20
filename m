Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3ETOtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:49:31 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:42420 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3ETOt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:49:27 -0400
Message-ID: <1369061360.4616.0.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 1/5] drivers: net: usb: rtl8150: moving constant and
 structure definitions out of rtl8150.c
From: Ben Hutchings <bhutchings@solarflare.com>
To: Petko Manolov <petkan@nucleusys.com>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 20 May 2013 15:49:20 +0100
In-Reply-To: <alpine.DEB.2.02.1305182306550.16874@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305182306550.16874@fry.nucleusys.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19878.004
X-TM-AS-Result: No--6.007700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-18 at 23:20 +0300, Petko Manolov wrote:
> From: Petko Manolov <petkan@nucleusys.com>
> 
> Moving constant and structure definitions out of rtl8150.c;
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>
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
[...]

Now how is this driver going to compile, when rtl8150.h is only added by
the next patch?!

You need to squash these first 2 together, so that the driver can be
compiled after each step.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

