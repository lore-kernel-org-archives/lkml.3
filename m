Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaBLIbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:31:19 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47952 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaBLIbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:31:16 -0500
Date: Wed, 12 Feb 2014 08:31:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: sachin.kamat@linaro.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, k.kozlowski@samsung.com,
        jdelvare@suse.de, linux@roeck-us.net
Subject: Re: [PATCH v7] mfd: MAX6650/6651 support
Message-ID: <20140212083110.GL15081@lee--X1>
References: <1392188969-18486-1-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392188969-18486-1-git-send-email-lpapp@kde.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
> chip includes fan-speed regulators and monitors, GPIO, and alarm.
> 
> This patch is an initial release of a MAX6650/6651 MFD driver that
> supports to enable the chip with its primary I2C bus that will connect
> the hwmon, and then the gpio devices for now.
> 
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/mfd/Kconfig                 | 11 +++++
>  drivers/mfd/Makefile                |  1 +
>  drivers/mfd/max665x.c               | 93 +++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/max665x-private.h | 34 ++++++++++++++
>  4 files changed, 139 insertions(+)
>  create mode 100644 drivers/mfd/max665x.c
>  create mode 100644 include/linux/mfd/max665x-private.h

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
