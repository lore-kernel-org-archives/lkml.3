Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3H0ILq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:11:46 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:34860 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3H0ILO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:11:14 -0400
Date: Tue, 27 Aug 2013 09:11:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 26/33] ARM: ux500: Remove AUXDATA relating to SDI (MMC)
 clock-name bindings
Message-ID: <20130827081109.GD6152@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-27-git-send-email-lee.jones@linaro.org>
 <CACRpkdb+WEecBEuFtoDLv9k3vyi=o0nZcLfCeny-7+uxdNBryA@mail.gmail.com>
 <201308240957.53944.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201308240957.53944.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Aug 2013, Arnd Bergmann wrote:

> On Friday 23 August 2013, Linus Walleij wrote:
> > On Thu, Jun 6, 2013 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > (...)
> > >         /* Requires DMA bindings. */
> > >         OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
> > > -       OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  &mop500_sdi0_data),
> > > -       OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  &mop500_sdi1_data),
> > > -       OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  &mop500_sdi2_data),
> > > -       OF_DEV_AUXDATA("arm,pl18x", 0x80114000, "sdi4",  &mop500_sdi4_data),
> > 
> > This cannot be done. Ulf H would beat me up if I applied this.
> > 
> > The platform data there in the end is actually used.
> > 
> > Especially look at mop500_sdi0_data, it contains a lot of stuff that is
> > not yet DT:ed even (a task in its own right).
> > 
> > But as long as we keep this pdata we can still delete ATAGs support (as
> > per the second patch set pending) and get a clearer picture.
> 
> Which parts of mop500_sdi0_data are not yet converted? I thought it was all covered
> months ago.

Well it would have been if you hadn't have stopped my CAPs patch. ;)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
