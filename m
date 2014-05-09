Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaEIKBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:01:00 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53600 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaEIKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:00:58 -0400
Date: Fri, 9 May 2014 11:00:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH] mfd: twl6040: Correct HPPLL configuration for 19.2 and
 38.4 MHz mclk
Message-ID: <20140509100053.GQ5767@lee--X1>
References: <1399365970-19543-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399365970-19543-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When the MCLK is 19.2 or 38.4 MHz the HPPLL need to be enabled and can be
> put in bypass mode.
> This will fix HPPLL use on boards with 19.2MHz mclk.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/mfd/twl6040.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
