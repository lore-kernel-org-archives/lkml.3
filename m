Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaFBTLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:11:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49690 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaFBTLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:11:22 -0400
Date: Mon, 2 Jun 2014 22:10:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Federico Di Pierro <nierro92@gmail.com>
Cc: jic23@kernel.org, gregkh@linuxfoundation.org, jg1.han@samsung.com,
        sachin.kamat@linaro.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix some coding style problem in
 drivers/staging/iio/frequency/ad9832.c
Message-ID: <20140602191053.GA15585@mwanda>
References: <538CAEBD.5040501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538CAEBD.5040501@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 07:05:01PM +0200, Federico Di Pierro wrote:
> -		else {
> +		} else {
>  			ret = -EINVAL;
>  			break;
>  		}
> 
> 
> Signed-off-by: Federico Di Pierro <nierro92@gmail.org>

This goes after the changelog and before the diff.

regards,
dan carpenter

