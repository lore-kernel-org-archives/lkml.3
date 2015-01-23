Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbbAWK1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:27:06 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45824 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbbAWK1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:27:01 -0500
Date: Fri, 23 Jan 2015 10:26:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] mfd: cros_ec: Instantiate ChromeOS EC character
 device
Message-ID: <20150123102655.GH9129@x1>
References: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
 <1421954186-29764-6-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421954186-29764-6-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Javier Martinez Canillas wrote:

> The ChromeOS EC character device is an user-space interface to
> allow applications to access the Embedded Controller.
> 
> Add a cell for this device so it's spawned from the mfd driver.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
> Changes since v2:
>  - Rename the name to "cros-ec-ctl". Suggested by Lee Jones.
> 
> Changes since v1: None, new patch.
> ---
>  drivers/mfd/cros_ec.c | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> index c872e1b0eaf8..c4aecc6f8373 100644
> --- a/drivers/mfd/cros_ec.c
> +++ b/drivers/mfd/cros_ec.c
> @@ -118,6 +118,10 @@ static const struct mfd_cell cros_devs[] = {
>  		.id = 2,
>  		.of_compatible = "google,cros-ec-i2c-tunnel",
>  	},
> +	{
> +		.name = "cros-ec-ctl",
> +		.id = 3,
> +	},
>  };
>  
>  int cros_ec_register(struct cros_ec_device *ec_dev)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
