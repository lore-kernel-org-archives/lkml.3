Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaD2HwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:52:10 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:36538 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaD2HwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:52:08 -0400
Date: Tue, 29 Apr 2014 08:52:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [PATCH v2 1/2] mfd: max77693: remove unnecessary wrapper
 functions
Message-ID: <20140429075202.GA29462@lee--X1>
References: <1398750527-20715-1-git-send-email-r.baldyga@samsung.com>
 <1398750527-20715-2-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398750527-20715-2-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch removes wrapper functions used to access regmap, and
> make driver using regmap_*() functions instead.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c     | 32 ++++++++++-----------
>  drivers/mfd/max77693-irq.c           | 50 +++++++++++++++++++-------------
>  drivers/mfd/max77693.c               | 56 ++----------------------------------
>  drivers/regulator/max77693.c         | 12 ++++----
>  include/linux/mfd/max77693-private.h |  8 ------
>  5 files changed, 54 insertions(+), 104 deletions(-)

Bye bye abstraction for the sake for abstraction. Works for me!

Acked-by: Lee Jones <lee.jones@linaro.org>

Chanwoo,
  I can add this to ib-mfd-extcon-3.16 with your Ack if you like.
  That should make things somewhat easier.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
