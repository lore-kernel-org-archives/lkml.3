Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3ILQHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:07:10 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36631 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3ILQHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:07:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130912112452.GA22013@e106331-lin.cambridge.arm.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
	<1378968687-8200-4-git-send-email-cinifr@gmail.com>
	<20130912112452.GA22013@e106331-lin.cambridge.arm.com>
Date: Fri, 13 Sep 2013 00:07:07 +0800
Message-ID: <CAK3cCBwu4somtfc9J1ZDVcC-iYD1qDJwSWzWeOomTqY9tQA2kg@mail.gmail.com>
Subject: Re: [PATCH 3/4] Add physical count arch timer support for clocksource
 in ARMv7.
From: cinifr <cinifr@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This cannot be a compile-time option as above in a multiplatform build.
>Other paltforms (e.g. KVM guests) *must* use the virtual counters to get
>any semblance of a consistent view of time.
Yes I accept compile-time option is not perfect  in my pre email,
But,Why Ohter paltforms *must* use the virtual counters? I think KVM
should not limit how to use arch timer in its guest OS. Of cause, if
KVM guest use vct can be more efficiency then that use pct. but KVM
should and must support guest OS to access pct.

>Why can the bootloader not be fixed to set CNTVOFF (or to boot the
>kernel in Hyp mode)?
I want kernel should try its best to boot and run with  the bootloader
not be fixed.
BTW, I also hope all bootloader fix the problem.
