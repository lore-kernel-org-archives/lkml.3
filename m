Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBNQyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:54:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBNQyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:54:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: dbx500/abx500: root out hardcoded IRQ assignments
Date: Fri, 14 Feb 2014 17:54:01 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
References: <1392114599-481-1-git-send-email-linus.walleij@linaro.org> <20140213131720.GC3403@lee--X1> <CACRpkdaoqwiy0n-oN0gKqgX_enGXw+BggRQy9yz8eQNyJ3MvsA@mail.gmail.com>
In-Reply-To: <CACRpkdaoqwiy0n-oN0gKqgX_enGXw+BggRQy9yz8eQNyJ3MvsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402141754.02159.arnd@arndb.de>
X-Provags-ID: V02:K0:wGSNe79hKOqU+L2V6oh0whEPwMRR8AqtaRZaB5bLZQc
 Ye5vFxrJdqd1tcAPTqgIsn+DBdRfV7miwIivMBvGd/+CcKZSiW
 TE8MH69JrXmTWfuZmTprQdbRENI8eKU1t0P/6DTntiEQ+YZXHj
 Q2eiYl+oxCNIFb6xX+NW3GkoW/8D+XAr96P3HK4kETezKzI6r2
 yuWdQdubs+Y8UHIU3w1FUlRwK6rRB+qDR0bBGRF/LN0288EuFT
 MBfWz7W8Hq7kfzcbdk7dFKpsMGbxCf9d7VX9N/+EAfxX4nCmy2
 +pXcuvzJVuJFTSTm8dFcqOlE70YZ1Sbq47Y3jS2YWxmzfg5HMb
 M8nx+BnLQtafXSwzEWiQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 February 2014, Linus Walleij wrote:
> On Thu, Feb 13, 2014 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >> <linus.walleij@linaro.org> wrote:
> >>
> >> > The DBx500 and ABx500 should be getting their IRQs from the
> >> > device tree and nowhere else. Get rid of all the static assignments
> >> > everywhere, delete it from the driver, platform data and the
> >> > board files in one swift strike.
> >> >
> >> > Lots of cross-dependencies in the MFD drivers for PRCMU and
> >> > AB8500 makes it necessary to strike everywhere at once to
> >> > eradicate IRQs passed as resources and platform data to the left
> >> > and right around the platform.
> >> >
> >> > Cc: Mark Brown <broonie@kernel.org>
> >> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> >> > Cc: Lee Jones <lee.jones@linaro.org>
> >> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >>
> >> OK no major complaints, Lee can you queue this in the MFD tree
> >> so we get some Linux-next rotation? If we need an immutable
> >> branch remains to be seen, maybe we can merge this throug MFD
> >> exclusively.
> >
> > I'm happy to do either, but the latter will require an ARM-SoC Ack.
> 
> OK Olof/Arnd/Kevin: can you ACK this patch for queueing
> through MFD? It only hits arch/arm/mach-ux500/*

Sounds good. Great job at cleaning up that stuff!

	Arnd
