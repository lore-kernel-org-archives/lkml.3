Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab3GKLPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:15:12 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41920 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab3GKLPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:15:11 -0400
Date: Thu, 11 Jul 2013 12:15:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ankur Raina <Ankur.Raina@kpitcummins.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, axel.lin@gmail.com,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        david.chen@diasemi.com,
        "Ashish P. Chavan" <Ashish.Chavan@kpitcummins.com>
Subject: Re: [patch v1]mfd: update DA9055 i2c device id
Message-ID: <20130711111503.GH25601@gmail.com>
References: <1373023094.1601.21.camel@ankurr1-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373023094.1601.21.camel@ankurr1-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jul 2013, Ankur Raina wrote:

> DA9055 is a combination of pmic and codec.
> This patch updates the DA9055 i2c device id to match the standard naming convention followed for such chips.
> 
> Signed-off-by: Ankur Raina <Ankur.Raina@kpitcummins.com>
> ---
>  drivers/mfd/da9055-i2c.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Again, I'm going to tinker with the commit message a little and apply
the patch.

> diff --git a/drivers/mfd/da9055-i2c.c b/drivers/mfd/da9055-i2c.c
> index 607387f..13af7e5 100644
> --- a/drivers/mfd/da9055-i2c.c
> +++ b/drivers/mfd/da9055-i2c.c
> @@ -54,7 +54,7 @@ static int da9055_i2c_remove(struct i2c_client *i2c)
>  }
>  
>  static struct i2c_device_id da9055_i2c_id[] = {
> -	{"da9055-pmic", 0},
> +	{"da9055", 0},
>  	{ }
>  };
>  

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
