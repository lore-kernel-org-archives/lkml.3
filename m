Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaBLIkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:40:13 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41504 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaBLIkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:40:10 -0500
Date: Wed, 12 Feb 2014 08:40:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        "'Patil, Rachna'" <rachna@ti.com>
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: Use devm_ioremap_resource()
Message-ID: <20140212084004.GN15081@lee--X1>
References: <000201cf27b3$ba62cc60$2f286520$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000201cf27b3$ba62cc60$2f286520$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use devm_ioremap_resource() in order to make the code simpler,
> and remove redundant return value check of platform_get_resource()
> because the value is checked by devm_ioremap_resource().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/ti_am335x_tscadc.c |   23 ++++-------------------
>  1 file changed, 4 insertions(+), 19 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
