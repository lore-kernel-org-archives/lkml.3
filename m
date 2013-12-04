Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab3LDM46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:56:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27892 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3LDM44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:56:56 -0500
Date: Wed, 4 Dec 2013 15:56:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gary Rookard <garyrookard@gmail.com>
Cc: gregkh@linuxfoundatio.org, devel@driverdev.osuosl.org,
        lisa@xenapiadmin.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: DDRInit: Fixed non_standard kernel style.
Message-ID: <20131204125646.GQ28413@mwanda>
References: <1386150789-7431-1-git-send-email-garyrookard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386150789-7431-1-git-send-email-garyrookard@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 04:53:09AM -0500, Gary Rookard wrote:
> Fixed non_standard kernel style.
> 

You're doing too many things at once, it needs to be broken into
a patch series which do one type of change at a time.

The changelog is useless.

> Signed off by: Gary Alan Rookard <garyrookard@gmail.com>
> ---
>  drivers/staging/bcm/DDRInit.c | 2081 +++++++++++++++++++----------------------
>  1 file changed, 977 insertions(+), 1104 deletions(-)
> 
> diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
> index 9f7e30f..2fc3ba9 100644
> --- a/drivers/staging/bcm/DDRInit.c
> +++ b/drivers/staging/bcm/DDRInit.c
> @@ -1,977 +1,876 @@
> -#include "headers.h"
> -
> +/* File: DDRInit.c */

This isn't useful.

> +	{0x0F000840, 0x0FFF1B00},  /* Changed Source for X-bar and MIPS Clock to APLL */
> +	{0xF0000870, 0x00000002},
> +	{0x0F00A044, 0x1FFFFFFF},
> +	{0x0F00A040, 0x1F000000},

One of these is not like the others.  You have introduced a bug with
0xF0000870 vs 0x0F000870.

regards,
dan carpenter
