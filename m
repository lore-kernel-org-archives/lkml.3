Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab3FLWAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:00:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42083 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab3FLWAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:00:37 -0400
Date: Thu, 13 Jun 2013 00:00:08 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4] irqchip: Add support for ARMv7-M's NVIC
Message-ID: <20130612220008.GG11232@pengutronix.de>
References: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 12, 2013 at 11:50:35PM +0200, Uwe Kleine-König wrote:
> This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.
> 
> Support for this controller appeared in Catalin's Cortex tree based on
> 2.6.33 but was nearly completely rewritten.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> 
> Notes:
>     Changes since v3, sent with
>     Message-Id: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de>:
>     
>      - use generic chip
>      - rename nvic_do_IRQ to nvic_handle_irq
>     
>     This depends on the stuff currently in tip/irq/for-arm
It also depends on Russell King's devel-stable branch. So the options to
apply it in case you are otherwise happy with it:

 - apply on top of tip/irq/for-arm dropping the change to
   arch/arm/kernel/entry-v7m.S and let me add that change seperately; or
 - let it go through Russell's tree (the dependency on tip/irq/for-arm
   doesn't stop the patch to be applied on that one, it just won't
   compile); or
 - wait until there is a tree that contains both branches; or
 - merge the two trees and apply it on top of the merge.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
