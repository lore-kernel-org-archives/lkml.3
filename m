Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaBQJCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:02:54 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:54470 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbaBQJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:02:50 -0500
Message-ID: <1392627768.10966.23.camel@x220>
Subject: Re: [PATCH] arm: imx: remove MACH_MXLADS
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Russell King <linux@arm.linux.org.uk>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
Date: Mon, 17 Feb 2014 10:02:48 +0100
In-Reply-To: <1392612187.657010375@f87.i.mail.ru>
References: <1392573811.28866.22.camel@x220>
	 <1392578464.996901773@f49.i.mail.ru> <1392582900.28866.85.camel@x220>
	 <1392612187.657010375@f87.i.mail.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2014 09:02:49.0693 (UTC) FILETIME=[0869C0D0:01CF2BBF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 08:43 +0400, Alexander Shiyan wrote:
> It seems that even in the current state, Kconfig for i.MX contains an error.
> As a start, we should rename ARCH_MX1ADS to MACH_MX1ADS first.

Last year I admitted that I didn't entirely grasped the differences
between "arch", "platform", and "machine" in the arch/arm universe[1].
Perhaps someone could help me understand why it's better to use
MACH_MX1ADS here.

Paul Bolle


[1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2013-May/038204.html

