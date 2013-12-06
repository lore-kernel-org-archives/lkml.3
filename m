Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3LFIY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:24:57 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58118 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3LFIYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:24:54 -0500
Message-ID: <52A189D2.3030500@free.fr>
Date: Fri, 06 Dec 2013 09:24:50 +0100
From: Duncan Sands <duncan.sands@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: learc83 <learc83@gmail.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Usb: atm: usbatm: fixed a pointer variable format issue
References: <1386302363-10975-1-git-send-email-learc83@gmail.com>
In-Reply-To: <1386302363-10975-1-git-send-email-learc83@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/13 04:59, learc83 wrote:
> Fixed a pointer variable format issue.

This is obviously OK.

Ciao, Duncan.

>
> Signed-off-by: Seth Archer Brown <learc83@gmail.com>
> ---
>   drivers/usb/atm/usbatm.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
> index 25a7bfc..dada014 100644
> --- a/drivers/usb/atm/usbatm.c
> +++ b/drivers/usb/atm/usbatm.c
> @@ -170,9 +170,9 @@ struct usbatm_control {
>   static void usbatm_atm_dev_close(struct atm_dev *atm_dev);
>   static int usbatm_atm_open(struct atm_vcc *vcc);
>   static void usbatm_atm_close(struct atm_vcc *vcc);
> -static int usbatm_atm_ioctl(struct atm_dev *atm_dev, unsigned int cmd, void __user * arg);
> +static int usbatm_atm_ioctl(struct atm_dev *atm_dev, unsigned int cmd, void __user *arg);
>   static int usbatm_atm_send(struct atm_vcc *vcc, struct sk_buff *skb);
> -static int usbatm_atm_proc_read(struct atm_dev *atm_dev, loff_t * pos, char *page);
> +static int usbatm_atm_proc_read(struct atm_dev *atm_dev, loff_t *pos, char *page);
>
>   static struct atmdev_ops usbatm_atm_devops = {
>   	.dev_close	= usbatm_atm_dev_close,
> @@ -739,7 +739,7 @@ static void usbatm_atm_dev_close(struct atm_dev *atm_dev)
>   	usbatm_put_instance(instance);	/* taken in usbatm_atm_init */
>   }
>
> -static int usbatm_atm_proc_read(struct atm_dev *atm_dev, loff_t * pos, char *page)
> +static int usbatm_atm_proc_read(struct atm_dev *atm_dev, loff_t *pos, char *page)
>   {
>   	struct usbatm_data *instance = atm_dev->dev_data;
>   	int left = *pos;
> @@ -895,7 +895,7 @@ static void usbatm_atm_close(struct atm_vcc *vcc)
>   }
>
>   static int usbatm_atm_ioctl(struct atm_dev *atm_dev, unsigned int cmd,
> -			  void __user * arg)
> +			  void __user *arg)
>   {
>   	struct usbatm_data *instance = atm_dev->dev_data;
>
>

