Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3ILMcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:32:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54376 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3ILMcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:32:47 -0400
Date: Thu, 12 Sep 2013 13:32:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/38] ARM: ux500: Remove PrimeCell IDs from Nomadik
	I2C DT nodes
Message-ID: <20130912123228.GJ12758@n2100.arm.linux.org.uk>
References: <CAOesGMgySNLKo_H0h4MCbAWvyW0h2bWa96drWBpnhAYYQwH9mw@mail.gmail.com> <20130910153037.GA11227@lee--X1> <CAOesGMiBN5SaEY26SxGaw9E4ViR3cC0PcwNMEd4cLJZMfomprQ@mail.gmail.com> <CACRpkdY24uU=tXirJqrxLH-45ORFGybJOg-2tDOkpSmFUQUiiw@mail.gmail.com> <20130911081911.GI11227@lee--X1> <CACRpkdY6v+LMggLBdfKc3VUPmRZXTf1zBi4a93EPhQeo21wMeQ@mail.gmail.com> <CAF2Aj3iPdqM-+FQ7R9MZ-6jV1Q1me9TG1P4cEGA7fSBBYH92zA@mail.gmail.com> <CACRpkdYfeao6bvwjq7YJhBNCoC_JVxPTwYzPPiWM0tgUQreJKg@mail.gmail.com> <CAOesGMi7zbGuBBaUToe7=PUJvUUT8FkdMAWzfCE0igpYiYTZSg@mail.gmail.com> <CACRpkdY-N_VJwdo4+y9-9==+iC_w4qSiiE2oY-hp_jgsJyxQbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY-N_VJwdo4+y9-9==+iC_w4qSiiE2oY-hp_jgsJyxQbg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:23:48PM +0200, Linus Walleij wrote:
> Yeah somewhere the bit-banging from the LL-prints that just
> hammer the hardware start conflicting with the kernel control
> over the same port. I guess it's the same for all users of the
> PL011.

That shouldn't happen, unless the port becomes disabled (eg, you're
not using the LL-debug port as your console, and its then placed into
a low power mode.)

Again, let me re-interate what LL-debug is for: it's there to assist
getting the early boot up and running.  Once the early boot is working,
it should *not* be used.
