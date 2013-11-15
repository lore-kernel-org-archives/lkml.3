Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3KOTOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:14:50 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:51176 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3KOTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:14:41 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1384514665-32174-1-git-send-email-nicolas.ferre@atmel.com>
References: <1384514665-32174-1-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 15 Nov 2013 11:14:40 -0800
Message-ID: <CAOesGMhTMxsqeAoGZ0VUSPC4c4i9_g3J38yyQRryRmSGPZ_Xnw@mail.gmail.com>
Subject: Re: [GIT PULL] at91: non-critical fixes for 3.13 #1
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Johan Hovold <jhovold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 3:24 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Arnd, Olof, Kevin,
>
> This is a pull-request for AT91 about non-critical fixes for 3.13. This means
> that you can certainly plan it for early 3.14.
> It is not a 3.13 regression as this issue has been present for ages. I have
> tagged the patch for "-stable" down to 3.11.y as they need modification to
> apply on older kernels.
>
> Thanks, best regards,
>
> The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:
>
>   Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes-non-critical
>
> for you to fetch changes up to 94c4c79f2f1acca6e69a50bff5a7d9027509c16b:
>
>   ARM: at91: fix hanged boot due to early rtt-interrupt (2013-11-15 12:13:33 +0100)
>
> ----------------------------------------------------------------
> Fixes for RTT & RTC interrupts that can fire early
> during boot process and kill the system.
> This fix has been discussed for months and it is time
> for it to reach mainline.


It's a bummer that this can't be fixed in firmware instead (since
there's a lot of devices out there with flashed firmware already,
etc).

We're early in the release cycle, and this is marked for -stable, so I
am pulling this into fixes for 3.13. It doesn't make sense to hold off
if it'll have to hit 3.13.y anyway.

So; pulled into fixes.


-Olof
