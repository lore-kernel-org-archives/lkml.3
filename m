Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaDHIUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:20:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbaDHIUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:20:16 -0400
Date: Tue, 8 Apr 2014 11:20:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging: rtl8192e: Fix declaration of symbols
Message-ID: <20140408082001.GA4912@mwanda>
References: <53420CEF.5040505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53420CEF.5040505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 09:26:55PM -0500, Joel Pelaez Jorge wrote:
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> @@ -19,6 +19,7 @@
> 
>  #include <linux/string.h>
>  #include "rtl_core.h"
> +#include "rtl_wx.h"
> 
>  #define RATE_COUNT 12
>  static u32 rtl8192_rates[] = {
> @@ -1320,7 +1321,7 @@ static struct iw_statistics
> *r8192_get_wireless_stats(struct net_device *dev)

This patch is line-wrapped and doesn't apply.  Read
Documentation/email-clients.txt or use git send-email.

regards,
dan carpenter

