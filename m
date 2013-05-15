Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab3EOLQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:16:25 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41989 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab3EOLQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <51935A67.6000804@solcon.nl>
References: <51935A67.6000804@solcon.nl>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 15 May 2013 21:16:02 +1000
Message-ID: <CAGRGNgUAkUB_FimqmUg4hyNpkVYKW-1vs2J=Tsr2juiineusrw@mail.gmail.com>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Add new USB ID
To: Albert Pool <albertpool@solcon.nl>
Cc: Larry Finger <larry.finger@lwfinger.net>, chaoming_li@realsil.com.cn,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Albert,

Your patch appears to have been mangled, please check your email
client's settings, or send using git-send-email

There's instructions for most email clients in the Documentation
directory of the kernel source tree.

On Wed, May 15, 2013 at 7:50 PM, Albert Pool <albertpool@solcon.nl> wrote:
> This adds the USB ID of the On Networks N300MA, clone of Netgear WNA3100M.
>
> Signed-off-by: Albert Pool <albertpool@solcon.nl>
>
> Reported-by: Ana Rey <Anazul77@hotmail.com>
>
> ---
>
>  drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    1 +
>
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>
> index 23d640a..0b593de 100644
>
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>
> @@ -349,6 +349,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
>
>      {RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
>
>      {RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
>
>      {RTL_USB_DEVICE(0x0846, 0x9021, rtl92cu_hal_cfg)}, /*Netgear-Sercomm*/
>
> +    {RTL_USB_DEVICE(0x0846, 0xf001, rtl92cu_hal_cfg)}, /*Netgear-On
> Networks*/
>
>      {RTL_USB_DEVICE(0x0b05, 0x17ab, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
>
>      {RTL_USB_DEVICE(0x0bda, 0x8186, rtl92cu_hal_cfg)}, /*Realtek 92CE-VAU*/
>
>      {RTL_USB_DEVICE(0x0df6, 0x0061, rtl92cu_hal_cfg)}, /*Sitecom-Edimax*/
>
> --
>
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
