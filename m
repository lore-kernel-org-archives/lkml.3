Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaD1KKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:10:22 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:37888 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaD1KKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:10:18 -0400
Date: Mon, 28 Apr 2014 11:10:10 +0100
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
Subject: Re: [PATCH v7 4/4] memstick: Add realtek USB memstick host driver
Message-ID: <20140428101010.GR6264@lee--X1>
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
 <1397199203-2235-5-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397199203-2235-5-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Roger Tseng <rogerable@realtek.com>
> 
> Realtek USB memstick host driver provides memstick host support based on the
> Realtek USB card reader MFD driver.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>  drivers/memstick/host/Kconfig       |  10 +
>  drivers/memstick/host/Makefile      |   1 +
>  drivers/memstick/host/rtsx_usb_ms.c | 839 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 850 insertions(+)
>  create mode 100644 drivers/memstick/host/rtsx_usb_ms.c

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
