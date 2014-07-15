Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbaGOKQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:16:59 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51088 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757853AbaGOKQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:16:56 -0400
Message-ID: <53C4FF90.7070306@mev.co.uk>
Date: Tue, 15 Jul 2014 11:16:48 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: sam-the-6 <asadi.samuel@gmail.com>, <hsweeten@visionengravers.com>,
        <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 91/93] Staging: comedi: 8253.h fixed by removing 'return'
 from generic func
References: <1405393999-25927-1-git-send-email-asadi.samuel@gmail.com>
In-Reply-To: <1405393999-25927-1-git-send-email-asadi.samuel@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-15 04:13, sam-the-6 wrote:
> From: Sam Asadi <asadi.samuel@gmail.com>
>
> Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
>
> 	modified:   drivers/staging/comedi/drivers/8253.h
> ---
>   drivers/staging/comedi/drivers/8253.h |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/8253.h b/drivers/staging/comedi/drivers/8253.h
> index 5829b46..f6b8607 100644
> --- a/drivers/staging/comedi/drivers/8253.h
> +++ b/drivers/staging/comedi/drivers/8253.h
> @@ -55,7 +55,7 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
>   	    /* check for overflow */
>   	    divider > div1 && divider > div2 &&
>   	    divider * i8253_osc_base > divider &&
> -	    divider * i8253_osc_base > i8253_osc_base) {
> +	    divider * i8253_osc_base > i8253_osc_base)	{

Keep the space before the '{'.  Don't replace it with a tab.

>   		return;
>   	}
>
> @@ -118,7 +118,6 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
>   	/*  masking is done since counter maps zero to 0x10000 */
>   	*d1 = div1 & 0xffff;
>   	*d2 = div2 & 0xffff;
> -	return;
>   }
>
>   #ifndef CMDTEST
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
