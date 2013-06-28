Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3F1MJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:09:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:45879 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3F1MJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:09:28 -0400
Date: Fri, 28 Jun 2013 14:09:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stehle Vincent-B46079 <B46079@freescale.com>
cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: next-20130627 breaks i.MX6 sabre sd UART console
In-Reply-To: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net>
Message-ID: <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Stehle Vincent-B46079 wrote:

Cc'ed Mark and Stephen.

> FYI I remark that today's Linux next 'next-20130627' breaks i.MX6
> sabre sd UART console with ARM config imx_v6_v7_defconfig.
> This was working fine yesterday with 'next-20130626'.
> 
> Bisecting gave me this commit:
> 
>   064706514ec3fea740c2656e03c4f01f6a551ac4 clocksource: Add generic
> dummy timer driver
> 
> If I revert it I do indeed get the boot messages on the UART console
> again, but the kernel then crashes in wm8962_probe(). So there is
> more to find out...
