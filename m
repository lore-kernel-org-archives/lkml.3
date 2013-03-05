Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3CEMIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 07:08:10 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:35976 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab3CEMIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:08:07 -0500
X-Greylist: delayed 1102 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Mar 2013 07:08:07 EST
X-Spam-Flag: NO
X-Spam-Score: -20.669
Message-ID: <5135DBD5.1070702@tremplin-utc.net>
Date: Tue, 05 Mar 2013 12:49:41 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Matthew Garrett <matthew.garrett@nebula.com>
CC: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
References: <s5h4ngz56yg.wl%tiwai@suse.de>
In-Reply-To: <s5h4ngz56yg.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/13 18:19, Takashi Iwai wrote:
> The DriveGuard chips on the new HP laptops are with a new PnP ID
> "HPQ6007".  It should be compatible with older chips.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
Hi,
Sorry for the delay. The driver is able to detect the actual type of 
accelerometer behind, so indeed it should work fine.

Thanks for the patch, here is my:
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>

Matthew, could you pick this patch into your tree?
Cheers,
Éric
>
> ---
>   drivers/platform/x86/hp_accel.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
> index e64a7a8..b6c4305 100644
> --- a/drivers/platform/x86/hp_accel.c
> +++ b/drivers/platform/x86/hp_accel.c
> @@ -77,6 +77,7 @@ static inline void delayed_sysfs_set(struct led_classdev *led_cdev,
>   static struct acpi_device_id lis3lv02d_device_ids[] = {
>   	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
>   	{"HPQ6000", 0}, /* HP Mobile Data Protection System PNP */
> +	{"HPQ6007", 0}, /* HP Mobile Data Protection System PNP */
>   	{"", 0},
>   };
>   MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
>

