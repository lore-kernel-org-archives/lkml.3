Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaL3WT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:19:27 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:40430 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbaL3WT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:19:26 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54A324E3.4070509@mev.co.uk>
Date: Tue, 30 Dec 2014 22:19:15 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: jitendra kumar khasdev <jkhasdev@gmail.com>, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, sudipm.mukherjee@gmail.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers: fix space coding style issue
 in s626.c
References: <1419844376-6660-1-git-send-email-jkhasdev@gmail.com>
In-Reply-To: <1419844376-6660-1-git-send-email-jkhasdev@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/12/14 09:12, jitendra kumar khasdev wrote:
> This is a patch to the s626.c file that fixes up a space error
> found by the checkpatch.pl tool
>
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> ---
>   drivers/staging/comedi/drivers/s626.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index 14932c5..fc497dd 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -118,7 +118,7 @@ static void s626_mc_enable(struct comedi_device *dev,
>   static void s626_mc_disable(struct comedi_device *dev,
>   			    unsigned int cmd, unsigned int reg)
>   {
> -	writel(cmd << 16 , dev->mmio + reg);
> +	writel(cmd << 16, dev->mmio + reg);
>   	mmiowb();
>   }

Presumably this is PATCH 1/2?

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
