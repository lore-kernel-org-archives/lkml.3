Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaDOK1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:27:00 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52832 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaDOK06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:26:58 -0400
Date: Tue, 15 Apr 2014 11:26:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Alessandro Gardich <gremlin@gremlin.it>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH v3] MFD: driver for Atmel Microcontroller on iPaq h3xxx
Message-ID: <20140415102649.GE27091@lee--X1>
References: <1396539915-22709-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396539915-22709-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This adds a driver for the Atmel Microcontroller found on the
> iPAQ h3xxx series. This device handles some keys, the
> touchscreen, and the battery monitoring.
> 
> This is a port of a driver from handhelds.org 2.6.21 kernel,
> written by Alessandro Gardich based on Andrew Christians
> original HAL-driver. It has been heavily cleaned and
> converted to mfd-core by Dmitry Artamonow and rewritten
> again for the v3.x series kernels by Linus Walleij,
> bringing back some of the functionality lost from Andrew's
> original driver.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Alessandro Gardich <gremlin@gremlin.it>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Pass a NULL parameter as suspend() function instead of
>   passing a dummy implementation. The core won't call this
>   anyway.
> 
> Lee: if you're OK with this version please merge it for v3.16
> after v3.15-rc1...
> ---
>  drivers/mfd/Kconfig            |  10 +
>  drivers/mfd/Makefile           |   1 +
>  drivers/mfd/ipaq-micro.c       | 482 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/ipaq-micro.h | 148 +++++++++++++
>  4 files changed, 641 insertions(+)
>  create mode 100644 drivers/mfd/ipaq-micro.c
>  create mode 100644 include/linux/mfd/ipaq-micro.h

Applied on trust that my previous comments have been addressed.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
