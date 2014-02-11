Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaBKKEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:04:38 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43105 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKKEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:04:00 -0500
Date: Tue, 11 Feb 2014 10:03:53 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Colin King <colin.king@canonical.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        rogerq@ti.com
Subject: Re: [PATCH][v2] mfd: omap-usb-tll: fix cppcheck sizeof warning
Message-ID: <20140211100353.GL32042@lee--X1>
References: <1392111533-23053-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392111533-23053-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Colin Ian King <colin.king@canonical.com>
> 
> Static analysis from cppcheck issued the following warning:
> 
> [drivers/mfd/omap-usb-tll.c:255]: (warning) Found calculation
>   inside sizeof().
> 
> The current size calculation is not obvious and is easy to
> miscomprehend, so re-work the size of the allocation based
> on the size of the struct pointer and quantity to allocate.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/mfd/omap-usb-tll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to my -fixes branch with Roger's Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
