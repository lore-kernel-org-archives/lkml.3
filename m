Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbaDPJP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:15:59 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45082 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaDPJPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:15:36 -0400
Date: Wed, 16 Apr 2014 10:15:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2] mfd: mc13xxx-core: Initialize the lock prior to using
 it
Message-ID: <20140416091531.GD4754@lee--X1>
References: <1397602574-28025-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397602574-28025-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> After request_threaded_irq() is called there is a chance that an interrupt
> may occur before the 'mc13xxx->lock' is initialized, which will trigger a kernel
> oops.
> 
> In order to prevent that, move the initialization of 'mc13xxx->lock' prior to
> requesting the interrupts.
> 
> Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Changes since v1:
> - Changed kernel warning --> kernel oops to better describe the problem
> - Added Russell's Ack

No you didn't. ;)

Applied with Russell's Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
