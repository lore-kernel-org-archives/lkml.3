Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbaESRPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:15:20 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:60356 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaESRPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:15:18 -0400
Date: Mon, 19 May 2014 18:15:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3] mfd: wm8997: Add registers for high power mode
Message-ID: <20140519171513.GB20435@lee--X1>
References: <1400517329-1103-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1400517329-1103-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400517329-1103-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some output configurations can require a 50Mhz SYSCLK which requires
> DCVDD to be 1.8V. This patch adds the registers necessary for
> supporting this operational mode.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8997-tables.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
