Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbbABSVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:21:12 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33510 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbbABSVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:21:11 -0500
Date: Fri, 2 Jan 2015 10:21:08 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, pankaj.saraf@nektech.in
Subject: Re: [PATCH 2/2] Staging: comedi: fix tab style issue
Message-ID: <20150102182108.GB1471@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	jitendra kumar khasdev <jkhasdev@gmail.com>, abbotti@mev.co.uk,
	hsweeten@visionengravers.com, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	pankaj.saraf@nektech.in
References: <1420215343-15006-1-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420215343-15006-1-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jitendra,

This is patch 2/2 but there is no 1/2.  Or was it that patch you sent
earlier?

On Fri, Jan 02, 2015 at 09:45:43PM +0530, jitendra kumar khasdev wrote:
> This is a patch to pcl818 that fix tab style error which is
> found by the checkpatch tool
> 
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> ---
>  drivers/staging/comedi/drivers/pcl818.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
> index c29223b..aa93d55 100644
> --- a/drivers/staging/comedi/drivers/pcl818.c
> +++ b/drivers/staging/comedi/drivers/pcl818.c
> @@ -47,7 +47,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
>      [3] - 0, 10=10MHz clock for 8254
>  		1= 1MHz clock for 8254
>      [4] - 0,  5=A/D input  -5V.. +5V
> -          1, 10=A/D input -10V..+10V
> +		1, 10=A/D input -10V..+10V
>      [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
>            1, 10=D/A output 0-10V (internal reference -10V)
>  	  2    =D/A output unknown (external reference)
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
