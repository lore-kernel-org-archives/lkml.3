Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaDCJsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:48:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51704 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaDCJsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:48:39 -0400
Date: Thu, 3 Apr 2014 12:48:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sherif <shehabaldin.sherif@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, silentquote@gmail.com
Subject: Re: [PATCH 7/9] driver: staging: wlan-ng: Fixed white spaces issues
Message-ID: <20140403094829.GI6991@mwanda>
References: <1396509209-3074-1-git-send-email-shehabaldin.sherif@gmail.com>
 <20140403074511.GY6991@mwanda>
 <533D1A01.30304@gmail.com>
 <20140403093855.GG6991@mwanda>
 <533D2D17.6060408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533D2D17.6060408@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 11:42:47AM +0200, Sherif wrote:
> Yes I enabled it:
> $ grep PRISM2_USB .config
> CONFIG_PRISM2_USB=m
> 
> But still getting the same output:
> $ make M=drivers/staging/wlan-ng/
>   Building modules, stage 2.
>   MODPOST 0 modules
> 

That's very odd.  It works for me.  I don't know what to tell you.

regards,
dan carpenter

