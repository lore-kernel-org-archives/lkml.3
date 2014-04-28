Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaD1Mv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:51:26 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:54040 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbaD1MvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:51:22 -0400
Date: Mon, 28 Apr 2014 13:51:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: sameo@linux.intel.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: twl6040: Optional clk32k clock handling
Message-ID: <20140428125116.GL21279@lee--X1>
References: <1396522482-32036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396522482-32036-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In certain boards the source for the clk32k clock can be gated. In these
> boards the clk32k clock can be provided to the driver and it is going to be
> enabled/disabled when it is needed.
> If the clk32k clock is not provided the driver will assume that it is always
> running.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  Documentation/devicetree/bindings/mfd/twl6040.txt |  2 ++
>  drivers/mfd/twl6040.c                             | 10 ++++++++++
>  include/linux/mfd/twl6040.h                       |  2 ++
>  3 files changed, 14 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
