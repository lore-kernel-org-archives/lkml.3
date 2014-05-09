Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaEIIJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:09:54 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:43360 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaEIIJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:09:51 -0400
Date: Fri, 9 May 2014 09:09:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 2/6] mfd: stmpe: add optional regulators
Message-ID: <20140509080946.GJ5767@lee--X1>
References: <1399583799-23517-1-git-send-email-linus.walleij@linaro.org>
 <1399583799-23517-2-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399583799-23517-2-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The STMPE has VCC and VIO supply lines, and sometimes (as on
> Ux500) this comes from a software-controlled regulator. Make
> it possible to supply the STMPE with power from these
> regulators.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/stmpe.c       | 18 ++++++++++++++++++
>  include/linux/mfd/stmpe.h |  5 +++++
>  2 files changed, 23 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
