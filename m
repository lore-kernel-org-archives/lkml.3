Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaEOJS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:18:26 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:51842 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaEOJSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:18:24 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s4F9ICmJ023706, This message is accepted by code: ctloc85258
Message-ID: <53748611.6040706@realtek.com>
Date: Thu, 15 May 2014 17:17:05 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/16] mfd: rtsx_usb: Make mfd_cell array const
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com> <1399978733-13662-7-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1399978733-13662-7-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/13/2014 06:58 PM, Krzysztof Kozlowski wrote:
> mfd_add_devices() expects array of struct mfd_cell to be const.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Roger Tseng <rogerable@realtek.com>
Acked-by: Roger Tseng <rogerable@realtek.com>
> ---
>   drivers/mfd/rtsx_usb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> index 141ea52c46e3..6352bec8419a 100644
> --- a/drivers/mfd/rtsx_usb.c
> +++ b/drivers/mfd/rtsx_usb.c
> @@ -29,7 +29,7 @@ static int polling_pipe = 1;
>   module_param(polling_pipe, int, S_IRUGO | S_IWUSR);
>   MODULE_PARM_DESC(polling_pipe, "polling pipe (0: ctl, 1: bulk)");
>
> -static struct mfd_cell rtsx_usb_cells[] = {
> +static const struct mfd_cell rtsx_usb_cells[] = {
>   	[RTSX_USB_SD_CARD] = {
>   		.name = "rtsx_usb_sdmmc",
>   		.pdata_size = 0,
>

Best regards,
Roger Tseng
