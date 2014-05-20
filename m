Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaETQPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:15:52 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:46994 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaETQPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:15:50 -0400
Date: Tue, 20 May 2014 17:15:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [RESEND PATCH v2] mfd: max77686: handle IRQs using regmap
Message-ID: <20140520161543.GC32025@lee--X1>
References: <1398692462-25757-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398692462-25757-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014, Robert Baldyga wrote:

> This patch modifies mfd driver to use regmap for handling interrupts.
> It allows to simplify irq handling process. This modifications needed
> to make small changes in function drivers, which use interrupts.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/Kconfig                  |   2 +-
>  drivers/mfd/Makefile                 |   2 +-
>  drivers/mfd/max77686-irq.c           | 319 -----------------------------------
>  drivers/mfd/max77686.c               |  54 +++++-
>  drivers/rtc/rtc-max77686.c           |  43 ++++-
>  include/linux/mfd/max77686-private.h |  32 +++-
>  6 files changed, 119 insertions(+), 333 deletions(-)
>  delete mode 100644 drivers/mfd/max77686-irq.c

I'm not going to complain at that diffstat.

So long as it works, patch applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
