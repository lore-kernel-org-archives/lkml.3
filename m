Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbaGYTGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:06:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758923AbaGYTGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:06:34 -0400
Message-ID: <53D2AAB4.1090109@redhat.com>
Date: Fri, 25 Jul 2014 21:06:28 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Julian Squires <julian@cipht.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: wacom_serial4 - prepare for wacom USB moving to
 HID
References: <20140724203108.GA9191@core.coreip.homeip.net>
In-Reply-To: <20140724203108.GA9191@core.coreip.homeip.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/24/2014 10:31 PM, Dmitry Torokhov wrote:
> wacom_wac.h will be moving to drivers/hid. Since we only need 3 definitions
> from it let's simply copy them over.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Ack, but you will want to drop the #include of wacom_wac.h yoo.

Regards,

Hans

> ---
>  drivers/input/tablet/wacom_serial4.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/input/tablet/wacom_serial4.c b/drivers/input/tablet/wacom_serial4.c
> index d3d251e..deef50e 100644
> --- a/drivers/input/tablet/wacom_serial4.c
> +++ b/drivers/input/tablet/wacom_serial4.c
> @@ -149,6 +149,11 @@ MODULE_LICENSE("GPL");
>  #define F_HAS_STYLUS2		0x02
>  #define F_HAS_SCROLLWHEEL	0x04
>  
> +/* device IDs */
> +#define STYLUS_DEVICE_ID	0x02
> +#define CURSOR_DEVICE_ID	0x06
> +#define ERASER_DEVICE_ID	0x0A
> +
>  enum { STYLUS = 1, ERASER, CURSOR };
>  
>  static const struct {
> 
