Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaFXMJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:09:31 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63343 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFXMJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:09:29 -0400
Date: Tue, 24 Jun 2014 13:09:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH v2] mfd: mc13xxx: Use regmap irq framework for interrupts
Message-ID: <20140624120923.GK13803@lee--X1>
References: <1403111140-17056-1-git-send-email-shc_work@mail.ru>
 <20140624092922.GE13803@lee--X1>
 <1403602651.181294577@f348.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403602651.181294577@f348.i.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Alexander Shiyan wrote:

> Tue, 24 Jun 2014 10:29:22 +0100 от Lee Jones <lee.jones@linaro.org>:
> > > This patch convert mc13xxx MFD driver to use regmap irq framework
> > > for interrupt registration.
> > > 
> > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > > ---
> > It's helpful if you add a v1 -> v2 changelog here, so we can keep up
> > with what's happening.
> 
> Yes, the basic changes are:
> - Use disable_irq_nosync() instead of disable_irq() due to usage this callback in the ISR.
> - Remove IRQF_ONESHOT flag from slave IRQs.
> ---

Very well.  Applied, thanks.


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
