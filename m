Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaKBDfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 23:35:30 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61125 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaKBDf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 23:35:27 -0400
Message-ID: <5455A676.2080305@gmail.com>
Date: Sun, 02 Nov 2014 10:35:18 +0700
From: Lars Melin <larsm17@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>, johan@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: option: Add ID for Peiker LTE NAD
References: <1414857669-1292-1-git-send-email-matthias.klein@linux.com>
In-Reply-To: <1414857669-1292-1-git-send-email-matthias.klein@linux.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-01 23:01, Matthias Klein wrote:
> Add ID of the Peiker LTE NAD for legacy serial interface
>
> Signed-off-by: Matthias Klein <matthias.klein@linux.com>
> ---
>   drivers/usb/serial/option.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index d1a3f60..d7f1042 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -1091,6 +1091,7 @@ static const struct usb_device_id option_ids[] = {
>   	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
>   	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
>   	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
> +	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9025)}, /* Peiker LTE NAD */
>   	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
>   	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },
>   	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6003),
05c6:9025 already has its net interface (#4) supported by the qmi_wwan 
driver so your patch is wrong.
There is also an ADB interface which I don't think should be driven by 
option.


