Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaKQJ7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:59:55 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:38265 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbaKQJ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:59:54 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <5469C717.5030709@mev.co.uk>
Date: Mon, 17 Nov 2014 09:59:51 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Marcus Hufvudsson <marcushuf@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: me4000: Fixed code style issue
References: <1416066920-10012-1-git-send-email-marcushuf@gmail.com>
In-Reply-To: <1416066920-10012-1-git-send-email-marcushuf@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/11/14 15:55, Marcus Hufvudsson wrote:
> Fixed checkpatch.pl error message. Space prohibited before that ','
>
> Signed-off-by: Marcus Hufvudsson <marcushuf@gmail.com>
> ---
>   drivers/staging/comedi/drivers/me4000.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
> index ae6ac49..fc67419 100644
> --- a/drivers/staging/comedi/drivers/me4000.c
> +++ b/drivers/staging/comedi/drivers/me4000.c
> @@ -416,7 +416,7 @@ static void me4000_reset(struct comedi_device *dev)
>   	val |= PLX9052_CNTRL_PCI_RESET;
>   	outl(val, info->plx_regbase + PLX9052_CNTRL);
>   	val &= ~PLX9052_CNTRL_PCI_RESET;
> -	outl(val , info->plx_regbase + PLX9052_CNTRL);
> +	outl(val, info->plx_regbase + PLX9052_CNTRL);
>
>   	/* 0x8000 to the DACs means an output voltage of 0V */
>   	for (chan = 0; chan < 4; chan++)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
