Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3FNJl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:41:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39591 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268Ab3FNJlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:41:24 -0400
Date: Fri, 14 Jun 2013 10:40:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>
Subject: Re: [PATCH v4] irqchip: Add support for ARMv7-M's NVIC
Message-ID: <20130614094011.GC8108@darko.cambridge.arm.com>
References: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:50:35PM +0100, Uwe Kleine-K??nig wrote:
> This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.
> 
> Support for this controller appeared in Catalin's Cortex tree based on
> 2.6.33 but was nearly completely rewritten.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>

Since you pretty much re-wrote my original code, you can drop my
Signed-off-by. Feel free to replace with:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
