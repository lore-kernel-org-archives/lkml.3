Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaEIIJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:09:15 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:52397 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaEIIJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:09:09 -0400
Date: Fri, 9 May 2014 09:09:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/6] mfd: stmpe: root out static GPIO and IRQ
 assignments
Message-ID: <20140509080904.GI5767@lee--X1>
References: <1399583799-23517-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399583799-23517-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only platform using the STMPE expander now boots from
> device tree using all-dynamic GPIO and IRQ number assignments, so
> remove the mechanism to pass this from the device tree entirely.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpio-stmpe.c | 18 +++++-------------
>  drivers/mfd/stmpe.c       |  3 +--
>  include/linux/mfd/stmpe.h | 14 --------------
>  3 files changed, 6 insertions(+), 29 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
