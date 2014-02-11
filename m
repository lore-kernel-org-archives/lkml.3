Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972AbaBKKCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:02:45 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37309 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:02:40 -0500
Date: Tue, 11 Feb 2014 10:02:33 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        wei_wang@realsil.com.cn, micky_ching@realsil.com.cn,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v3 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140211100233.GK32042@lee--X1>
References: <1391697307-23457-1-git-send-email-rogerable@realtek.com>
 <1391697307-23457-2-git-send-email-rogerable@realtek.com>
 <20140210113054.GE21522@lee--X1>
 <52F9F012.8030302@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52F9F012.8030302@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Roger wrote:

> On 02/10/2014 07:30 PM, Lee Jones wrote:
> >>From: Roger Tseng <rogerable@realtek.com>
> >>
> >>Realtek USB card reader provides a channel to transfer command or data to flash
> >>memory cards. This driver exports host instances for mmc and memstick subsystems
> >>and handles basic works.
> >>
> >>Signed-off-by: Roger Tseng <rogerable@realtek.com>
> >>---
> >>  drivers/mfd/Kconfig          |  10 +
> >>  drivers/mfd/Makefile         |   1 +
> >>  drivers/mfd/rtsx_usb.c       | 760 +++++++++++++++++++++++++++++++++++++++++++
> >>  include/linux/mfd/rtsx_usb.h | 628 +++++++++++++++++++++++++++++++++++
> >>  4 files changed, 1399 insertions(+)
> >>  create mode 100644 drivers/mfd/rtsx_usb.c
> >>  create mode 100644 include/linux/mfd/rtsx_usb.h
> >
> >Applied with Greg's Ack.
> >
> Thanks. But I have to modify some places in PATCH 2/3 and 3/3
> according to Ulf's suggestion. I will resend v4 later but currently
> I don't plan to change the 1/3 part(for mfd) in it.
> 
> Would you wait for and re-apply the v4 submission or give any advice?

Yes, no problem.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
