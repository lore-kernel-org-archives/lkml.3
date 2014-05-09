Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaEIIK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:10:26 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:62720 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaEIIKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:10:20 -0400
Date: Fri, 9 May 2014 09:10:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 3/6] mfd: stmpe: probe properly from the device
 tree
Message-ID: <20140509081015.GK5767@lee--X1>
References: <1399583799-23517-1-git-send-email-linus.walleij@linaro.org>
 <1399583799-23517-3-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399583799-23517-3-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current STMPE I2C probing code does not really match the
> compatible strings - it matches node names happening to give
> the right device name. Instead, let's introduce some real
> compatible matching, more complex, more accurate. Make the
> driver depend on OF since all platforms using it are DT-only.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Fix a stupid error where I left a dangling return statement
>   in the probe path.
> - Fix up subject prope->probe
> ChangeLog v1->v2:
> - Make driver depend on OF and remove some ifdeffery that way.
> - Squash OF match table to single lines.
> - Merge of-specific probe function into probe().
> - Print a small nag if DT is using the node name trick to make
>   the driver probe.
> ---
>  drivers/mfd/Kconfig     |  1 +
>  drivers/mfd/stmpe-i2c.c | 30 +++++++++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)

This patch is already applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
