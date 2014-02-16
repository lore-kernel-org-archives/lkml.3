Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaBPTMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:12:49 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:57744 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbaBPTMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:12:48 -0500
Message-ID: <1392577965.28866.37.camel@x220>
Subject: Re: [PATCH] arm: imx: remove MACH_MXLADS
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Russell King <linux@arm.linux.org.uk>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
Date: Sun, 16 Feb 2014 20:12:45 +0100
In-Reply-To: <1392577615.265469392@f161.i.mail.ru>
References: <1392573811.28866.22.camel@x220>
	 <1392574562.956803244@f244.i.mail.ru> <1392576223.28866.24.camel@x220>
	 <1392577615.265469392@f161.i.mail.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 19:12:46.0580 (UTC) FILETIME=[1371CB40:01CF2B4B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-16 at 23:06 +0400, Alexander Shiyan wrote:
> Kconfig selects MACH_MXLADS, this enables machine_arch_type
> from include/generated/mach-types.h which used for machine_is_xx() macro,
> so if multiple boards is defined in the kernel, this cause to incorrect matching.

But, as I stated in the commit explanation, there are no users of
machine_is_mxlads().

> Russel, Arnd, fixme.

What does that mean?


Paul Bolle

