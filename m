Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbaCUKzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:55:45 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:46666 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120AbaCUKzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:55:39 -0400
Date: Fri, 21 Mar 2014 10:55:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: arizona: Mark DSP clocking register as volatile
Message-ID: <20140321105534.GK15213@lee--X1>
References: <1395334164-3012-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395334164-3012-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395334164-3012-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The DSPs will often control there own clock speeds whilst running as
> such we should mark the registers controlling this as volatile.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c |    1 +
>  drivers/mfd/wm5110-tables.c |    4 ++++
>  2 files changed, 5 insertions(+), 0 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
