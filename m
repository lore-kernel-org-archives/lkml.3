Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaD1KKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:10:55 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61485 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbaD1KKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:10:53 -0400
Date: Mon, 28 Apr 2014 11:10:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn
Subject: Re: [PATCH v7 3/4] mmc: Add realtek USB sdmmc host driver
Message-ID: <20140428101047.GS6264@lee--X1>
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
 <1397199203-2235-4-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397199203-2235-4-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Roger Tseng <rogerable@realtek.com>
> 
> Realtek USB SD/MMC host driver provides mmc host support based on the Realtek
> USB card reader MFD driver.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/mmc/host/Kconfig          |    7 +
>  drivers/mmc/host/Makefile         |    1 +
>  drivers/mmc/host/rtsx_usb_sdmmc.c | 1455 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 1463 insertions(+)
>  create mode 100644 drivers/mmc/host/rtsx_usb_sdmmc.c

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
