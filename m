Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaBZMwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:52:06 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60593 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaBZMwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:52:04 -0500
Date: Wed, 26 Feb 2014 12:51:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        Cyril Chemparathy <cyril@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 4/5] mfd: remove obsolete ti-ssp driver
Message-ID: <20140226125157.GM9195@lee--X1>
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
 <1393418614-3968549-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393418614-3968549-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The tnetv107x platform is getting removed, so this driver
> is not needed any more.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/Kconfig  |  11 --
>  drivers/mfd/Makefile |   1 -
>  drivers/mfd/ti-ssp.c | 465 ---------------------------------------------------
>  3 files changed, 477 deletions(-)
>  delete mode 100644 drivers/mfd/ti-ssp.c

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
