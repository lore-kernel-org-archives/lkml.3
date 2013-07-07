Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab3GGLol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 07:44:41 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:39902 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3GGLoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 07:44:17 -0400
Message-ID: <51D9548B.9040907@gmail.com>
Date: Sun, 07 Jul 2013 13:44:11 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC timer
References: <51B8D310.4050404@linaro.org>
In-Reply-To: <51B8D310.4050404@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 09:59 PM, Daniel Lezcano wrote:
>
> The following changes since commit 762cf9695d714d312ef7369bed1b9f9467c9e64e:
>
>    Merge branch 'timers/clockevents' of
> git://git.linaro.org/people/dlezcano/clockevents into timers/core
> (2013-06-08 22:58:27 +0200)
>
> are available in the git repository at:
>
>
>    git://git.linaro.org/people/dlezcano/clockevents.git timers/clockevents
>
> for you to fetch changes up to fbb3cb01505e7365c70a7fe680e10ffff3175160:
>
>    clocksource: Add Marvell Orion SoC timer (2013-06-11 14:41:01 +0200)
>
> ----------------------------------------------------------------
> Sebastian Hesselbarth (1):
>        clocksource: Add Marvell Orion SoC timer

Thomas, John,

with tip timers/core PR sent, I realized that the above did not make it
in. As we have a whole bunch of cleanup and DT conversion patches for
v3.11-rc1 depending on it, would it be ok for you to let Jason Cooper
take it through his ARM sub-branch?

If you are fine with it, I will resend the patch and note that Daniel
can drop it and Jason will take it.

Sebastian

>   .../bindings/timer/marvell,orion-timer.txt         |   17 +++
>   drivers/clocksource/Kconfig                        |    5 +
>   drivers/clocksource/Makefile                       |    1 +
>   drivers/clocksource/time-orion.c                   |  150
> ++++++++++++++++++++
>   4 files changed, 173 insertions(+)
>   create mode 100644
> Documentation/devicetree/bindings/timer/marvell,orion-timer.txt
>   create mode 100644 drivers/clocksource/time-orion.c

