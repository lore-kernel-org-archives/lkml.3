Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbbARPXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 10:23:21 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:49701 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbbARPXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 10:23:18 -0500
Message-ID: <54BBCFE2.9030801@gmail.com>
Date: Sun, 18 Jan 2015 17:23:14 +0200
From: =?UTF-8?B?R2llZHJpdXMgU3RhdGtldmnEjWl1cw==?= 
	<giedrius.statkevicius@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ahmadposten <ahmad.hassan612@gmail.com>, devel@driverdev.osuosl.org
CC: gclement@baobob.org, tvboxspy@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, forest@alittletooquiet.net,
        joe@perches.com
Subject: Re: [PATCH] staging: vt6655: fix space prohibted before that ','
 Signed-off-by: Ahmadposten <ahmad.hassan612@gmail.com>
References: <20150118233831.GA22696@Arch-Thinkpad>
In-Reply-To: <20150118233831.GA22696@Arch-Thinkpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015.01.19 01:38, Ahmadposten wrote:
> ---
>  drivers/staging/vt6655/device_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
> index f5cc78e..34e3a76 100644
> --- a/drivers/staging/vt6655/device_main.c
> +++ b/drivers/staging/vt6655/device_main.c
> @@ -1090,7 +1090,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
>  	// Must do this after doing rx/tx, cause ISR bit is slow
>  	// than RD/TD write back
>  	// update ISR counter
> -	STAvUpdate802_11Counter(&pDevice->s802_11Counter, &pDevice->scStatistic , dwMIBCounter);
> +	STAvUpdate802_11Counter(&pDevice->s802_11Counter, &pDevice->scStatistic, dwMIBCounter);
>  	while (pDevice->dwIsr != 0) {
>  		STAvUpdateIsrStatCounter(&pDevice->scStatistic, pDevice->dwIsr);
>  		MACvWriteISR(pDevice->PortOffset, pDevice->dwIsr);
> 
Your subject is messed up. The Signed-off-by part should be in the
message before "---". Also, consider adding some text that describes
more precisely what you've changed. By the way, as a newbie you can
always send your patches to yourself before sending it off to a ML to
see if everything is okay.

-- 
Thanks,
Giedrius
