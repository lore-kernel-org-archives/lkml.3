Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3GAMBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:01:49 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43607 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3GAMBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:01:47 -0400
MIME-Version: 1.0
In-Reply-To: <1372362463-4186-1-git-send-email-naresh.bhat@linaro.org>
References: <1372362463-4186-1-git-send-email-naresh.bhat@linaro.org>
Date: Mon, 1 Jul 2013 17:31:46 +0530
Message-ID: <CAFoFrHa_XsKaWDag_k3o_Lgizsf+qZUYPjBn9pvWSe83BY8sOg@mail.gmail.com>
Subject: Re: [PATCH] ACPI/fan: Initialize acpi_state variable
From: Naresh Bhat <naresh.bhat@linaro.org>
To: linux-acpi@vger.kernel.org
Cc: len.brown@intel.com, Patch Tracking <patches@linaro.org>,
        linaro-kernel@lists.linaro.org, Naresh Bhat <naresh.bhat@linaro.org>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafeal,

I appreciate if you give any feedback on the provided patch.

Thanks
-Naresh Bhat

On 28 June 2013 01:17,  <naresh.bhat@linaro.org> wrote:
> From: Naresh Bhat <naresh.bhat@linaro.org>
>
>   CC      drivers/acpi/fan.o
> drivers/acpi/fan.c: In function ‘fan_get_cur_state’:
> drivers/acpi/fan.c:96:9: warning: ‘acpi_state’ may be used uninitialized in this function [-Wuninitialized]
> ---
>  drivers/acpi/fan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> index f815da8..f961435 100644
> --- a/drivers/acpi/fan.c
> +++ b/drivers/acpi/fan.c
> @@ -84,7 +84,7 @@ static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long
>  {
>         struct acpi_device *device = cdev->devdata;
>         int result;
> -       int acpi_state;
> +       int acpi_state = ACPI_STATE_D0;
>
>         if (!device)
>                 return -EINVAL;
> --
> 1.7.9.5
>
