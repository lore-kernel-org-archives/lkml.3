Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaFXPsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:48:42 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54155 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaFXPsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:48:40 -0400
Date: Tue, 24 Jun 2014 16:48:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jim Davis <jim.epost@gmail.com>, sfr@canb.auug.org.au,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, sbkim73@samsung.com,
        sameo@linux.intel.com, grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: randconfig build error with next-20140624, in
 drivers/mfd/sec-core.c
Message-ID: <20140624154833.GR13803@lee--X1>
References: <CA+r1ZhhFYip3Jp2c3d8tNpD-vK8Pkf7DzrKTtk6Gy8uOOO3Ucw@mail.gmail.com>
 <29237234.T7oGEGKuvp@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29237234.T7oGEGKuvp@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Arnd Bergmann wrote:

> On Tuesday 24 June 2014 07:39:04 Jim Davis wrote:
> > Building with the attached random configuration file,
> > 
> > drivers/built-in.o: In function `sec_pmic_suspend':
> > sec-core.c:(.text+0x31e02c): undefined reference to `regulator_suspend_prepare'
> > make: *** [vmlinux] Error 1
> 
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 207c433..1caa3c5 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -582,7 +582,7 @@ config MFD_RC5T583
>  
>  config MFD_SEC_CORE
>  	bool "SAMSUNG Electronics PMIC Series Support"
> -	depends on I2C=y
> +	depends on I2C=y && REGULATOR
>  	select MFD_CORE
>  	select REGMAP_I2C
>  	select REGMAP_IRQ

Can you send me something I can `git am` please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
