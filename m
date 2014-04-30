Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaD3BQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:16:08 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:42004 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaD3BQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:16:06 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3U1Fms3001233, This message is accepted by code: ctloc85258
Message-ID: <53604FBE.2050701@realsil.com.cn>
Date: Wed, 30 Apr 2014 09:19:58 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC: <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: rts5208: fix static checker warnings
References: <1396432732-26514-1-git-send-email-micky_ching@realsil.com.cn>
In-Reply-To: <1396432732-26514-1-git-send-email-micky_ching@realsil.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

I have send this patch to fix the static checker warning, but not 
applied yet.

Best Regards.
micky.
On 04/02/2014 05:58 PM, micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> The patch fa590c222fba: "staging: rts5208: add support for rts5208
> and rts5288" from Nov 12, 2013, leads to the following static checker
> warning:
> 	drivers/staging/rts5208/rtsx_chip.c:107 rtsx_enable_bus_int()
> 	warn: add curly braces?
> This warning is produced because incorrect code indent.
>
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>   drivers/staging/rts5208/rtsx_chip.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
> index 6426807..7907e93 100644
> --- a/drivers/staging/rts5208/rtsx_chip.c
> +++ b/drivers/staging/rts5208/rtsx_chip.c
> @@ -104,7 +104,7 @@ void rtsx_enable_bus_int(struct rtsx_chip *chip)
>   	if (chip->ic_version >= IC_VER_C)
>   		reg |= DELINK_INT_EN;
>   #ifdef SUPPORT_OCP
> -		reg |= OC_INT_EN;
> +	reg |= OC_INT_EN;
>   #endif
>   	if (!chip->adma_mode)
>   		reg |= DATA_DONE_INT_EN;

