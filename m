Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3IMHH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:07:57 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:37542 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3IMHHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:07:55 -0400
Date: Fri, 13 Sep 2013 08:07:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>
Subject: Re: [PATCH V2] mfd: timberdale: remove unnecessary pci_set_drvdata()
Message-ID: <20130913070751.GS11227@lee--X1>
References: <001501ceaf83$1e558220$5b008660$%han@samsung.com>
 <001701ceaf83$8921e6c0$9b65b440$%han@samsung.com>
 <000401ceb028$4cb42d60$e61c8820$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000401ceb028$4cb42d60$e61c8820$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013, Jingoo Han wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL. It also removes unnecessary label such
> as 'err_request'.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v1:
> - Removed unnecessary label such as 'err_request'.
> 
>  drivers/mfd/timberdale.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c

Looks fine to me now.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
