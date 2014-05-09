Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaEIIKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:10:49 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:64849 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaEIIKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:10:44 -0400
Date: Fri, 9 May 2014 09:10:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 4/6] mfd: stmpe: mask off unused blocks properly
Message-ID: <20140509081039.GL5767@lee--X1>
References: <1399583799-23517-1-git-send-email-linus.walleij@linaro.org>
 <1399583799-23517-4-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399583799-23517-4-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The STMPE driver would just read/modify/write the system control
> register on the STMPE1601, meaning it would not properly mask off
> the PWM block, which remained active if it was on at boot time.
> This makes sure the blocks are always masked off if they were
> active on boot, saving some power. Also rename the inconsistenty
> named STMPE1601 define for the PWM block activation.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/stmpe.c | 9 +++++++++
>  drivers/mfd/stmpe.h | 2 +-
>  2 files changed, 10 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
