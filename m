Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbaEILhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:37:54 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:52780 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaEILhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:37:53 -0400
Date: Fri, 9 May 2014 12:37:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        lgirdwood@gmail.com, broonie@kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v3 2/2] mfd: max77693: handle IRQs using regmap
Message-ID: <20140509113747.GX5767@lee--X1>
References: <1398762747-1138-1-git-send-email-r.baldyga@samsung.com>
 <1398762747-1138-3-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398762747-1138-3-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch modifies mfd driver to use regmap for handling interrupts.
> It allows to simplify irq handling process. This modifications needed
> to make small changes in function drivers, which use interrupts.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> [For extcon part]
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c     |   3 +-
>  drivers/mfd/Kconfig                  |   1 +
>  drivers/mfd/Makefile                 |   2 +-
>  drivers/mfd/max77693-irq.c           | 346 -----------------------------------
>  drivers/mfd/max77693.c               | 158 ++++++++++++++--
>  include/linux/mfd/max77693-private.h |  46 ++++-
>  6 files changed, 195 insertions(+), 361 deletions(-)
>  delete mode 100644 drivers/mfd/max77693-irq.c

Patch looks good now:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
