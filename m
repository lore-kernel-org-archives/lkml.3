Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaD1KnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:43:22 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43821 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaD1KnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:43:19 -0400
Date: Mon, 28 Apr 2014 11:43:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        sameo@linux.intel.com, nm@ti.com
Subject: Re: [RESEND 3/3] mfd: twl6040: Clear the interrupt ID register
 before requesting IRQ
Message-ID: <20140428104313.GL21279@lee--X1>
References: <1396359901-32656-1-git-send-email-peter.ujfalusi@ti.com>
 <1396359901-32656-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396359901-32656-4-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If for some reason the boot loader enabled the audpwron GPIO we will have
> pending IRQs to be handled. This seams to break twl6040 for some reason
> leading to non working i2c communication (i2c timeouts). Clearing the INTID
> register after we requested the audpwron GPIO (and set it to low) will
> ensure that the chip will operate normally in this case as well.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/mfd/twl6040.c | 3 +++
>  1 file changed, 3 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
