Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162462AbaDCHpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:45:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29215 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162347AbaDCHpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:45:21 -0400
Date: Thu, 3 Apr 2014 10:45:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, silentquote@gmail.com
Subject: Re: [PATCH 7/9] driver: staging: wlan-ng: Fixed white spaces issues
Message-ID: <20140403074511.GY6991@mwanda>
References: <1396509209-3074-1-git-send-email-shehabaldin.sherif@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396509209-3074-1-git-send-email-shehabaldin.sherif@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 09:13:29AM +0200, Sherif Shehab Aldin wrote:
>  static void hfa384x_usbctlx_resptimerfn(unsigned long data)
>  {
> -	hfa384x_t *hw = (hfa384x_t *) data;
> +	hfa384x_t *hw = (hfa384x_t *)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&hw->ctlxq.lock, flags);

This breaks the build.

regards,
dan carpenter
