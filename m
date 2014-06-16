Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaFPOwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:52:14 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56150 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPOwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:52:13 -0400
Date: Mon, 16 Jun 2014 15:52:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH RESEND] mfd: timberdale: Depend on X86_32
Message-ID: <20140616145206.GZ14323@lee--X1>
References: <20140616135601.5f700de1@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140616135601.5f700de1@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Jean Delvare wrote:

> As far as I know the Timberdale chip was only used as a companion for
> Intel Atom E600 series processors. As such, its drivers are only
> useful on X86_32.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
> Patch already sent on: 2014-04-03

Applied, thanks.

>  drivers/mfd/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-3.16-rc1.orig/drivers/mfd/Kconfig	2014-06-16 13:00:58.359698968 +0200
> +++ linux-3.16-rc1/drivers/mfd/Kconfig	2014-06-16 13:02:12.995215489 +0200
> @@ -1055,7 +1055,7 @@ config MFD_LM3533
>  config MFD_TIMBERDALE
>  	tristate "Timberdale FPGA"
>  	select MFD_CORE
> -	depends on PCI && GPIOLIB
> +	depends on PCI && GPIOLIB && (X86_32 || COMPILE_TEST)
>  	---help---
>  	This is the core driver for the timberdale FPGA. This device is a
>  	multifunction device which exposes numerous platform devices.
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
