Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3LRJ06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:26:58 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52977 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3LRJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:26:55 -0500
Date: Wed, 18 Dec 2013 09:26:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH v4 0/2] mfd: rtsx: decrease driver size and add new device
Message-ID: <20131218092649.GC14274@lee--X1>
References: <cover.1387331869.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1387331869.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> we add a macro to simplify setting pull control, and use a common init
> function to init the common params for 8411-like chips. at last we add
> support for rtl8402 chip.
> 
> Micky Ching (2):
>   mfd: rtsx: add set pull control macro and simplify rtl8411
>   mfd: rtsx: add support for card reader rtl8402
> 
>  drivers/mfd/rtl8411.c  |   95 ++++++++++++++++++++++++++----------------------
>  drivers/mfd/rtsx_pcr.c |    5 +++
>  drivers/mfd/rtsx_pcr.h |    9 +++++
>  3 files changed, 66 insertions(+), 43 deletions(-)

Nice.

Applied with Dan's Reviewed-by.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
