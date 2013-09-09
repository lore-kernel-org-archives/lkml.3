Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab3IIJDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 05:03:20 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:60998 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3IIJDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 05:03:18 -0400
Date: Mon, 9 Sep 2013 10:03:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: sm501: dbg_regs attribute must be read-only
Message-ID: <20130909090313.GD22938@lee--X1>
References: <1378625136-8823-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378625136-8823-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Sep 2013, Guenter Roeck wrote:

> Fix:
> 
> sm501 sm501: SM501 At b3e00000: Version 050100a0, 8 Mb, IRQ 100
> Attribute dbg_regs: write permission without 'store'
> ------------[ cut here ]------------
> WARNING: at drivers/base/core.c:620
> 
> dbg_regs does not have a write function and must therefore be marked
> as read-only.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/mfd/sm501.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
