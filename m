Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaBCJVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:21:19 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:41270 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaBCJVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:21:17 -0500
Date: Mon, 3 Feb 2014 09:21:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Andrea Adami <andrea.adami@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] mfd: include all drivers in subsystem menu
Message-ID: <20140203092111.GC13529@lee--X1>
References: <1390990193-3064-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390990193-3064-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is currently not possible to select the SA1100 or Vexpress
> drivers in the MFD subsystem, because the menu for the entire
> subsystem ends before these options are presented.
> 
> Move the main menu closing and the endif for HAS_IOMEM to the
> end of the file so these are selectable again.
> 
> Cc: stable@vger.kernel.org
> Cc: Andrea Adami <andrea.adami@gmail.com>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
