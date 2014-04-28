Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaD1Kme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:42:34 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:42784 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaD1Kmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:42:32 -0400
Date: Mon, 28 Apr 2014 11:42:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        sameo@linux.intel.com, nm@ti.com
Subject: Re: [RESEND 1/3] mfd: twl6040: Select i2c fast mode as default with
 regmap patch
Message-ID: <20140428104226.GJ21279@lee--X1>
References: <1396359901-32656-1-git-send-email-peter.ujfalusi@ti.com>
 <1396359901-32656-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396359901-32656-2-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All boards using twl6040 configures the i2c bus to 400KHz. While twl6040's
> defaults to normal mode (100KHz). So far twl6040 has no problem with i2c
> communication in this configuration it is safer to select fast i2c mode.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/mfd/twl6040.c       | 9 +++++++--
>  include/linux/mfd/twl6040.h | 1 +
>  2 files changed, 8 insertions(+), 2 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
