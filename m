Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbaCRU3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:29:44 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:57532 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757AbaCRU3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:29:41 -0400
Date: Tue, 18 Mar 2014 20:29:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Sekhar Nori <nsekhar@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/3] mfd: remove obsolete ti-ssp driver
Message-ID: <20140318202936.GV25478@lee--X1>
References: <1395154561-1199121-1-git-send-email-arnd@arndb.de>
 <1395154561-1199121-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395154561-1199121-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The tnetv107x platform is getting removed, so this driver
> is not needed any more.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> Acked-by: Kevin Hilman <khilman@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/Kconfig  |  11 --
>  drivers/mfd/Makefile |   1 -
>  drivers/mfd/ti-ssp.c | 465 ---------------------------------------------------
>  3 files changed, 477 deletions(-)
>  delete mode 100644 drivers/mfd/ti-ssp.c

Re-applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
