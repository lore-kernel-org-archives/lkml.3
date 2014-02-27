Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaB0Lyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:54:49 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43227 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaB0Lyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:54:47 -0500
Date: Thu, 27 Feb 2014 11:54:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: ucb1x00-core: Use SIMPLE_DEV_PM_OPS macro
Message-ID: <20140227115442.GA24910@lee--X1>
References: <000b01cf33b0$8c7f3000$a57d9000$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000b01cf33b0$8c7f3000$a57d9000$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Jingoo Han wrote:

> Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/ucb1x00-core.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
