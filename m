Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3KRRxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:53:03 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37773 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3KRRw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:52:56 -0500
Date: Mon, 18 Nov 2013 17:52:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Michal Marek <mmarek@suse.cz>
Cc: sameo@linux.intel.com, ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Make MFD_AS3722 depend on I2C=y
Message-ID: <20131118175251.GR13640@lee--X1>
References: <1384795559-2116-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384795559-2116-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Michal Marek wrote:

> MFD_AS3722 can only be builtin, so it needs I2C builtin as well.
> With I2C=m, we get:
> 
> drivers/mfd/as3722.c:372: undefined reference to `devm_regmap_init_i2c'
> drivers/built-in.o: In function `as3722_i2c_driver_init':
> drivers/mfd/as3722.c:444: undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `as3722_i2c_driver_exit':
> drivers/mfd/as3722.c:444: undefined reference to `i2c_del_driver'
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Looks fine. Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
