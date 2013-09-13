Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab3IMOzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:55:11 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41336 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3IMOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:55:09 -0400
MIME-Version: 1.0
In-Reply-To: <523315CD.8010704@arm.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
	<1378968687-8200-4-git-send-email-cinifr@gmail.com>
	<20130912112452.GA22013@e106331-lin.cambridge.arm.com>
	<CAK3cCBwu4somtfc9J1ZDVcC-iYD1qDJwSWzWeOomTqY9tQA2kg@mail.gmail.com>
	<5231EE43.5090900@arm.com>
	<CAK3cCBzr8_LTYarZDgPYZY7_-5Qco_Qw+ACi=c2uOrn7MqwkBg@mail.gmail.com>
	<5232DB49.4050701@arm.com>
	<CAK3cCBw4EKypLmhf4L5_P3d27QzsrB+ZxUTgF58YhmUhBa00xQ@mail.gmail.com>
	<523315CD.8010704@arm.com>
Date: Fri, 13 Sep 2013 22:55:07 +0800
Message-ID: <CAK3cCBwsbsdBoRX3Gnz5KpUVMQk0pnuUD+2WhZscBA+pDaat5g@mail.gmail.com>
Subject: Re: [PATCH 3/4] Add physical count arch timer support for clocksource
 in ARMv7.
From: cinifr <cinifr@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> This doesn't change the fact that using the physical timer/counter in a
> VM is (or can be) horribly expensive, and should be avoided at all cost.
>
I will remove suport phy timer counter patch and try to fix it in
bootloader.  I agree that is elegant only vct is be used.in kernel
now.
