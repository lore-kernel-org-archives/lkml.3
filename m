Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaBYOXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:23:03 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:35886 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaBYOXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:23:00 -0500
Date: Tue, 25 Feb 2014 14:22:53 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: twl6040: Remove duplicate register write
Message-ID: <20140225142253.GB9195@lee--X1>
References: <1393334900-29740-1-git-send-email-florian.vaussard@epfl.ch>
 <1393334900-29740-3-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393334900-29740-3-git-send-email-florian.vaussard@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When probing, regmap_register_patch() will bypass the cache and perform
> i2c writes for the given patches. It is thus unnecessary to manually set
> the TWL6040_REG_ACCCTL register just before, as it will be done when
> registering the twl6040_patch.
> 
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  drivers/mfd/twl6040.c | 1 -
>  1 file changed, 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
