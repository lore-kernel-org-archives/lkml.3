Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaETQVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:21:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54746 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaETQVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:21:24 -0400
Date: Tue, 20 May 2014 17:21:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [PATCH v4 2/3] mfd: max8997: handle IRQs using regmap
Message-ID: <20140520162119.GA32496@lee--X1>
References: <1398693358-28336-1-git-send-email-r.baldyga@samsung.com>
 <1398693358-28336-3-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398693358-28336-3-git-send-email-r.baldyga@samsung.com>
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
> 
> [For extcon part]
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |   3 +-
>  drivers/mfd/Kconfig                 |   2 +-
>  drivers/mfd/Makefile                |   2 +-
>  drivers/mfd/max8997-irq.c           | 373 -----------------------------------
>  drivers/mfd/max8997.c               | 112 ++++++++++-

For the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

>  drivers/rtc/rtc-max8997.c           |   2 +-
>  include/linux/mfd/max8997-private.h |  63 +++++-
>  7 files changed, 165 insertions(+), 392 deletions(-)
>  delete mode 100644 drivers/mfd/max8997-irq.c

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
