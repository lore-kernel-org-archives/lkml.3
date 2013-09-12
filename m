Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3ILPLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:11:30 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:60170 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3ILPL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:11:29 -0400
Date: Thu, 12 Sep 2013 16:11:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Heiko Schocher'" <hs@denx.de>
Subject: Re: [PATCH 2/3] mfd: sm501: remove unnecessary pci_set_drvdata()
Message-ID: <20130912151125.GM11227@lee--X1>
References: <001501ceaf83$1e558220$5b008660$%han@samsung.com>
 <001601ceaf83$56ead450$04c07cf0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <001601ceaf83$56ead450$04c07cf0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Jingoo Han wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/sm501.c |    2 --
>  1 file changed, 2 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
