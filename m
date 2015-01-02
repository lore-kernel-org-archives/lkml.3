Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbbABST3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:19:29 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34201 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbABST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:19:28 -0500
Date: Fri, 2 Jan 2015 10:19:24 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, pankaj.saraf@nektech.in
Subject: Re: [PATCH] Staging: comedi: tab space coding style issue in pcl818.c
Message-ID: <20150102181924.GA1471@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	jitendra kumar khasdev <jkhasdev@gmail.com>, abbotti@mev.co.uk,
	hsweeten@visionengravers.com, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	pankaj.saraf@nektech.in
References: <1420214864-14793-1-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420214864-14793-1-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jitendra,

On Fri, Jan 02, 2015 at 09:37:44PM +0530, jitendra kumar khasdev wrote:
> This is patch to the pcl818.c that fix up a use tab error
> found by the checkpatch.pl tool
> ---
Your Signed-off-by is missing.

>  drivers/staging/comedi/drivers/pcl818.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
> index 8edea35..c29223b 100644
> --- a/drivers/staging/comedi/drivers/pcl818.c
> +++ b/drivers/staging/comedi/drivers/pcl818.c
> @@ -45,7 +45,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
>      [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
>      [2] - DMA	(0=disable, 1, 3)
>      [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> +		1= 1MHz clock for 8254
>      [4] - 0,  5=A/D input  -5V.. +5V
>            1, 10=A/D input -10V..+10V
>      [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
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
