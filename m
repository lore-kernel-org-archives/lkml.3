Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaBNJog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:44:36 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63880 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaBNJoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:44:34 -0500
Date: Fri, 14 Feb 2014 09:44:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn
Subject: Re: [PATCH v4 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140214094427.GA7380@lee--X1>
References: <1392199238-14500-1-git-send-email-rogerable@realtek.com>
 <1392199238-14500-2-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392199238-14500-2-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, rogerable@realtek.com wrote:

> From: Roger Tseng <rogerable@realtek.com>
> 
> Realtek USB card reader provides a channel to transfer command or data to flash
> memory cards. This driver exports host instances for mmc and memstick subsystems
> and handles basic works.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>  drivers/mfd/Kconfig          |  10 +
>  drivers/mfd/Makefile         |   1 +
>  drivers/mfd/rtsx_usb.c       | 760 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/rtsx_usb.h | 628 +++++++++++++++++++++++++++++++++++
>  4 files changed, 1399 insertions(+)
>  create mode 100644 drivers/mfd/rtsx_usb.c
>  create mode 100644 include/linux/mfd/rtsx_usb.h

Applied again, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
