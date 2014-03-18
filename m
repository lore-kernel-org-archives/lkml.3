Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaCRItN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:49:13 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:47143 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaCRItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:49:08 -0400
Date: Tue, 18 Mar 2014 08:49:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Matt Porter <mporter@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: bcm590xx: Fix type argument for module device table
Message-ID: <20140318084902.GE25478@lee--X1>
References: <1394846690.8939.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394846690.8939.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This fixes below build error.
> 
> FATAL: drivers/mfd/bcm590xx: sizeof(struct i2c_device_id)=24 is not a modulo of the size of section __mod_i2c_device_table=392.
> Fix definition of struct i2c_device_id in mod_devicetable.h
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/bcm590xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
