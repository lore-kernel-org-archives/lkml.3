Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaEILhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:37:09 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56566 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaEILhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:37:07 -0400
Date: Fri, 9 May 2014 12:37:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        lgirdwood@gmail.com, broonie@kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v3 1/2] mfd: max77693: remove unnecessary wrapper
 functions
Message-ID: <20140509113701.GW5767@lee--X1>
References: <1398762747-1138-1-git-send-email-r.baldyga@samsung.com>
 <1398762747-1138-2-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398762747-1138-2-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch removes wrapper functions used to access regmap, and
> make driver using regmap_*() functions instead.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> [For extcon part]
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c     | 32 ++++++++++-----------
>  drivers/mfd/max77693-irq.c           | 50 +++++++++++++++++++-------------
>  drivers/mfd/max77693.c               | 56 ++----------------------------------
>  drivers/regulator/max77693.c         | 12 ++++----
>  include/linux/mfd/max77693-private.h |  8 ------
>  5 files changed, 54 insertions(+), 104 deletions(-)

I guess we still need a regulator Ack before I can apply this.

Mark?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
