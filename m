Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3CMUh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:37:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18493 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3CMUhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:37:55 -0400
Date: Wed, 13 Mar 2013 23:37:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jacob Garber <ajtgarber@gmail.com>
Cc: greg@kroah.com, devel@driverdev.osuosl.org, fmhess@users.sourceforge.net,
        abbotti@mev.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: Fixed camel case style issue in usbdux.c
Message-ID: <20130313203718.GG9138@mwanda>
References: <1363191560-4410-1-git-send-email-ajtgarber@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363191560-4410-1-git-send-email-ajtgarber@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 12:19:20PM -0400, Jacob Garber wrote:
> This is a patch to usbdux.c that fixes the camel case warnings found
> by the checkpatch.pl tool
> 
> Signed-off-by: Jacob Garber <ajtgarber@gmail.com>
> ---
> -static int usbduxsub_submit_InURBs(struct usbduxsub *usbduxsub)
> +static int usbduxsub_submit_inurbs(struct usbduxsub *usbduxsub)
>  {
> -	int i, errFlag;
> +	int i, err_flag;
>  

This is really just a regular error code, not a flag.  But that was
there in the original so no worries.

Looks good.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

