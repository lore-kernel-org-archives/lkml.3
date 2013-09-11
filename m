Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3IKIRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:17:24 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34070 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3IKIRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:17:21 -0400
Date: Wed, 11 Sep 2013 09:17:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LinusW <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 01/38] ARM: ux500: Remove PrimeCell IDs from Nomadik I2C
 DT nodes
Message-ID: <20130911081717.GH11227@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-2-git-send-email-lee.jones@linaro.org>
 <CAOesGMgySNLKo_H0h4MCbAWvyW0h2bWa96drWBpnhAYYQwH9mw@mail.gmail.com>
 <20130910153037.GA11227@lee--X1>
 <CAOesGMiBN5SaEY26SxGaw9E4ViR3cC0PcwNMEd4cLJZMfomprQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMiBN5SaEY26SxGaw9E4ViR3cC0PcwNMEd4cLJZMfomprQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Olof Johansson wrote:

> [pruning out the iio list/people]
> 
> On Tue, Sep 10, 2013 at 8:30 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >> On Tue, Sep 10, 2013 at 5:49 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >> > Turns out that they're actually not required and the driver probes just
> >> > fine without them. The ID is incorrect at the moment anyway. They actually
> >> > currently specify the stn8815.
> >> >
> >> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >>
> >> How did you test this patch? What hardware did you boot it on and with
> >> what config?
> >
> > Snowball, u8500_defconfig.
> >
> > Why? Don't you have the same result with yours?
> 
> I have a very weird experience with snowball right now. I noticed this
> yesterday when I decided to look at why multi_v7_defconfig doesn't
> boot on it:
> 
> * u8500_defconfig doesn't boot as a DT kernel, since the machine ID is
> still enabled. If I disable the machine ID, it doesn't boot.
> * Same for multi_v7_defconfig, since that is only DT: It doesn't boot.

I'm not entirely sure what you mean by this, as I have Snowball
booting as a Device Tree only platform:

  http://www.spinics.net/lists/kernel/msg1590759.html

The Machine ID should be all F's for DT I think.

> Unfortunately I can't get to my home network right now to double-check
> boot logs to see if this has changed behavior recently, I'll have to
> do that later today. It'd be interesting to hear if you have the same
> experience w.r.t. DT on u8500_defconfig though.

I just changed SNOWBALL's machine ID to 9999 and it still boots just
fine with DT (ATAGs boot hangs). So what did you do? Can you send me
a patch of what you did, so I might reproduce your build please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
