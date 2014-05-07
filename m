Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaEGImR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:42:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30098 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaEGImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:42:15 -0400
Date: Wed, 7 May 2014 11:41:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: John Church <j.church@ymail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, georgiana.chelu93@gmail.com,
        waydi1@gmail.com
Subject: Re: [PATCH] Staging: android: fix coding style issue in timed_gpio.c
Message-ID: <20140507084156.GX26890@mwanda>
References: <5369D165.1080400@ymail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5369D165.1080400@ymail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 07:23:33AM +0100, John Church wrote:
> This patch fixes a coding style issue. It modifies a single line
> that was over 80 characters long.
> 
> Thanks,
> John

> Signed-off-by: John Church <j.church@ymail.com>

This patch isn't sent in the correct way.  Use git send-email or
read Documentation/email-clients.txt.  Send the patch to yourself.
Save it as raw text including headers and everything.
`cat raw_email.txt | git am`.  Review the log with "git log -p".  When
that looks good then resend it to the list.

> 
> --- linux-next/drivers/staging/android/timed_gpio.c.orig	2014-05-07 00:20:50.429090320 +0100
> +++ linux-next/drivers/staging/android/timed_gpio.c	2014-05-07 00:22:09.204795052 +0100
> @@ -92,7 +92,7 @@ static int timed_gpio_probe(struct platf
>  		return -EBUSY;
>  
>  	gpio_data = devm_kzalloc(&pdev->dev,
> -				sizeof(struct timed_gpio_data) * pdata->num_gpios,
> +			sizeof(struct timed_gpio_data) * pdata->num_gpios,
>  				GFP_KERNEL);

To be honest, I prefered the original because everything lined up nicely
in the original.  Now it just looks whacky.

regards,
dan carpenter

>  	if (!gpio_data)
>  		return -ENOMEM;

