Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaDPIOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:14:04 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40066 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbaDPIN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:13:58 -0400
Date: Wed, 16 Apr 2014 09:13:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>, rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Oliver Neukum <oneukum@suse.de>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Subject: Re: [PATCH v7 4/4] memstick: Add realtek USB memstick host driver
Message-ID: <20140416081352.GA4754@lee--X1>
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

Hi Andrew,

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

It seems Max and Alex are less than interested in this patch, so I'm
going to apply it anyway. In your last review you mentioned that it
looked good to your inexpert eye. Can I apply your Ack to that effect?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
