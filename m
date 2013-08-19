Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938Ab3HSP0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:26:15 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55388 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3HSP0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:26:13 -0400
Date: Mon, 19 Aug 2013 08:26:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
Message-ID: <20130819152610.GA28431@roeck-us.net>
References: <52082EF8.10005@roeck-us.net>
 <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130813034054.GA18218@roeck-us.net>
 <CAFEAcA_-S8z6ZMr8TMPvkcTyyCSMOj1DExVsY4JDQjRXDU5WGw@mail.gmail.com>
 <20130815175428.GA18580@roeck-us.net>
 <CAFEAcA_MyJPwo6Gd_dxeWM5q5-7MYqR6-rrePusFzYaGGckWJQ@mail.gmail.com>
 <20130815205044.GA21599@roeck-us.net>
 <CAFEAcA-ALD+dDWAB+Rd1V+TXQLYGe-qRKC0uFUP0Bt2SGfKDRg@mail.gmail.com>
 <520D53CA.6040807@roeck-us.net>
 <CAFEAcA8sOKOs6iQBu7iBdFWW8GymTGR8XSXOceorxzoEoyddNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA8sOKOs6iQBu7iBdFWW8GymTGR8XSXOceorxzoEoyddNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 11:23:58PM +0100, Peter Maydell wrote:
> On 15 August 2013 23:18, Guenter Roeck <linux@roeck-us.net> wrote:
> > But doesn't that mean that there is _currently_ no problem ? If so,
> > we can introduce the additional code when the problem really shows up.
> > Being Preemptive is good, but if it is not really needed today
> > I would rather have today's problems resolved and bother about tomorrow's
> > when they show up.
> 
> Conceptually the two parts go together: rely on correct
> irq routing, tell qemu we rely on correct irq routing.
> It's only one extra line...
> 
Possibly, but the lack of progress suggests that by tying both parts
together we might get neither accepted.

Old saying - surgery successful, patient dead.

Guenter
