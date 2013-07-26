Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab3GZKfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:35:08 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:36988 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab3GZKfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:35:05 -0400
Date: Fri, 26 Jul 2013 12:35:00 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/10] ARM: sunxi: Add the Allwinner A31 compatible to
 the machine definition
Message-ID: <20130726123500.58136be1@skate>
In-Reply-To: <1374618312-19001-4-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
	<1374618312-19001-4-git-send-email-maxime.ripard@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Maxime Ripard,

On Wed, 24 Jul 2013 00:25:05 +0200, Maxime Ripard wrote:
> The Allwinner A31 is a quad-Cortex-A7 based SoC, which shares a lot of
> differences with the previous SoCs from Allwinner, like the PIO, I2C,

"shares a lot of differences" ? I suppose you meant "has a lot of
similarities", or "shares a number of hardware blocks", or something
like that?

> UARTs, timers, watchdog IPs, but also differs but droping the WEMAC

"but also differs but droping" ?

> ethernet controller and most notably droping the in-house IRQ
> controller in favor of a ARM GIC one.

droping -> dropping

</nitpick> :)

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
