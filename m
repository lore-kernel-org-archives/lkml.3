Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaFBQhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:37:04 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:65171 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaFBQhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:37:02 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:31f0:6efe:5ec:e3ba]
In-Reply-To: <1401726901-19093-1-git-send-email-nicolas.ferre@atmel.com>
References: <1401726901-19093-1-git-send-email-nicolas.ferre@atmel.com>
Date: Mon, 2 Jun 2014 09:37:01 -0700
Message-ID: <CAOesGMj1FuozbydRf=J7jWFt_8GZ8ZKZReg_1BmvPC706cZ7rQ@mail.gmail.com>
Subject: Re: [GIT PULL] at91: drivers for 3.16 #1
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        egtvedt@samfundet.no, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 2, 2014 at 9:35 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Arnd, Olof, Kevin,
>
> Here is an additional AT91 pull-request for 3.16 about drivers and
> particularly focused on PWM.
> Alexandre did a great job replacing the existing calls to the older,
> non-standard drivers by the use of the newer "pwm-atmel" which takes
> advantage of the PWM framework.
> In addition of removing three obsolete drivers, it also solves an issue with
> non existing Kconfig symbols introduced by (misc: atmel_pwm: only build for
> supported platforms) which was trying to avoid a build failure... so, all in
> all, a pretty good thing!
>
> The drawback is that this series depends on two git trees:
>
> Obviously, one from Thierry:
> git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm
>
> And as well the one from Greg who took Arnd's patch for Kconfig:
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
>
> Tell me if you feel it is the proper way to deal with this or if it is too late
> for this round (look at the diffstat, yummy ;-))
>
> Thanks, best regards,
>
> The following changes since commit fa264e615338c423e344d34621f992858b957097:
>
>   Merge branch 'char-misc-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc into at91-3.16-drivers (2014-06-02 18:02:18 +0200)
>
> are available in the git repository at:
>
>
>   git://github.com/at91linux/linux-at91.git tags/at91-drivers

The 3.16 merge window is open, please resend after -rc1.


-Olof
