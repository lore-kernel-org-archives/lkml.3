Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbbAZLj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:39:29 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:51824 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbbAZLj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:39:26 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54C6276B.1040803@mev.co.uk>
Date: Mon, 26 Jan 2015 11:39:23 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Simon Guo <wei.guo.simon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc5 03/03] STAGING: Fix pcl818.c coding style issue:
 no space before tabs
References: <20150125094858.GD4076@thunderCat>
In-Reply-To: <20150125094858.GD4076@thunderCat>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/15 09:48, Simon Guo wrote:
> Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
> - please, no space before tabs
>
> Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
> ---
>   drivers/staging/comedi/drivers/pcl818.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
> index 0873617..a1f366f 100644
> --- a/drivers/staging/comedi/drivers/pcl818.c
> +++ b/drivers/staging/comedi/drivers/pcl818.c
> @@ -84,7 +84,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
>   	      2=             +/-2.5V
>   	      3=             +/-1V
>   	      4=             +/-0.5V
> -	      5=  	     user defined bipolar
> +	      5=	     user defined bipolar
>   	      6=	     0-10V
>   	      7=	     0-5V
>   	      8=	     0-2V
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
