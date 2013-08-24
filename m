Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3HXH6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 03:58:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61287 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3HXH6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 03:58:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 26/33] ARM: ux500: Remove AUXDATA relating to SDI (MMC) clock-name bindings
Date: Sat, 24 Aug 2013 09:57:53 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org> <1370521041-32318-27-git-send-email-lee.jones@linaro.org> <CACRpkdb+WEecBEuFtoDLv9k3vyi=o0nZcLfCeny-7+uxdNBryA@mail.gmail.com>
In-Reply-To: <CACRpkdb+WEecBEuFtoDLv9k3vyi=o0nZcLfCeny-7+uxdNBryA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308240957.53944.arnd@arndb.de>
X-Provags-ID: V02:K0:a3f6ypMB2oXQkjhSPx4EY7/XT1rdM5fiDIbhHCxk9xX
 W/McKaeJd7CBl2Sci5q2eCgpkAJfrb6BvbK9HQYN6OD+vnr3aH
 PL3dEUsr1w45W3gy7XoTY0vy8ZxKcjYexaZDth3qYimJOoVVAu
 W3bsvIW+pAxtNRXwJS/X+O3+t/MRGfKTdFXWT5o6swATTwdSxg
 itBVO75JN0oEh1rABaxrV5PIgT8uk7kQBOWWmD0lQfN5Lt/bU7
 6WNsXPj6BSFTMPgKSvvH7pPOYOVdD4EoXAAu/Es0j4WDUOtt9Z
 +mkabohxzbldn+0FDMuCaB+3eDwazGAps93lxgS1rIcGwol5FE
 vNPPEfkmGrXl96oEUnGY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 August 2013, Linus Walleij wrote:
> On Thu, Jun 6, 2013 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> (...)
> >         /* Requires DMA bindings. */
> >         OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
> > -       OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  &mop500_sdi0_data),
> > -       OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  &mop500_sdi1_data),
> > -       OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  &mop500_sdi2_data),
> > -       OF_DEV_AUXDATA("arm,pl18x", 0x80114000, "sdi4",  &mop500_sdi4_data),
> 
> This cannot be done. Ulf H would beat me up if I applied this.
> 
> The platform data there in the end is actually used.
> 
> Especially look at mop500_sdi0_data, it contains a lot of stuff that is
> not yet DT:ed even (a task in its own right).
> 
> But as long as we keep this pdata we can still delete ATAGs support (as
> per the second patch set pending) and get a clearer picture.

Which parts of mop500_sdi0_data are not yet converted? I thought it was all covered
months ago.

	Arnd
