Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3JVROH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:14:07 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43758 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3JVROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:14:05 -0400
Date: Tue, 22 Oct 2013 18:13:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, kishon@ti.com
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: avoid possible deadlock of
 reg_lock
Message-ID: <20131022171359.GC2620@lee--X1>
References: <1382451159-25183-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382451159-25183-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013, Sebastian Andrzej Siewior wrote:

> Since the addition of continuous sampling mode and shared irq support,
> the reg_lock lock can be taken with and without interrupts. This patch
> uses the *_irq* variant which should be used in order to avaoid a deadlock.
> 
> Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/mfd/ti_am335x_tscadc.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Good catch. Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
