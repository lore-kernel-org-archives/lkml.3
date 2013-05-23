Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3EWHfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:35:22 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47725 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3EWHfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:35:21 -0400
Date: Thu, 23 May 2013 08:35:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Leon Romanovsky <leon@leon.nu>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mfd: tps65912: Convert to use devm_kzalloc
Message-ID: <20130523073516.GA22683@gmail.com>
References: <1368609586-20905-1-git-send-email-leon@leon.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368609586-20905-1-git-send-email-leon@leon.nu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013, Leon Romanovsky wrote:

> There is no need to call kfree while using devm_kzalloc,
> remove it from *_device_init function.
> 
> Signed-off-by: Leon Romanovsky <leon@leon.nu>
> ---
>  drivers/mfd/tps65912-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Applied thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
