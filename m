Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3HOWYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:24:20 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:59161 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3HOWYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:24:18 -0400
MIME-Version: 1.0
In-Reply-To: <520D53CA.6040807@roeck-us.net>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk>
 <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130813034054.GA18218@roeck-us.net> <CAFEAcA_-S8z6ZMr8TMPvkcTyyCSMOj1DExVsY4JDQjRXDU5WGw@mail.gmail.com>
 <20130815175428.GA18580@roeck-us.net> <CAFEAcA_MyJPwo6Gd_dxeWM5q5-7MYqR6-rrePusFzYaGGckWJQ@mail.gmail.com>
 <20130815205044.GA21599@roeck-us.net> <CAFEAcA-ALD+dDWAB+Rd1V+TXQLYGe-qRKC0uFUP0Bt2SGfKDRg@mail.gmail.com>
 <520D53CA.6040807@roeck-us.net>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 15 Aug 2013 23:23:58 +0100
Message-ID: <CAFEAcA8sOKOs6iQBu7iBdFWW8GymTGR8XSXOceorxzoEoyddNA@mail.gmail.com>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
To: Guenter Roeck <linux@roeck-us.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 August 2013 23:18, Guenter Roeck <linux@roeck-us.net> wrote:
> But doesn't that mean that there is _currently_ no problem ? If so,
> we can introduce the additional code when the problem really shows up.
> Being Preemptive is good, but if it is not really needed today
> I would rather have today's problems resolved and bother about tomorrow's
> when they show up.

Conceptually the two parts go together: rely on correct
irq routing, tell qemu we rely on correct irq routing.
It's only one extra line...

-- PMM
