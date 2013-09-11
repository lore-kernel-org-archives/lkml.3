Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3IKITS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:19:18 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57616 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3IKITP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:19:15 -0400
Date: Wed, 11 Sep 2013 09:19:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 01/38] ARM: ux500: Remove PrimeCell IDs from Nomadik I2C
 DT nodes
Message-ID: <20130911081911.GI11227@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-2-git-send-email-lee.jones@linaro.org>
 <CAOesGMgySNLKo_H0h4MCbAWvyW0h2bWa96drWBpnhAYYQwH9mw@mail.gmail.com>
 <20130910153037.GA11227@lee--X1>
 <CAOesGMiBN5SaEY26SxGaw9E4ViR3cC0PcwNMEd4cLJZMfomprQ@mail.gmail.com>
 <CACRpkdY24uU=tXirJqrxLH-45ORFGybJOg-2tDOkpSmFUQUiiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY24uU=tXirJqrxLH-45ORFGybJOg-2tDOkpSmFUQUiiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Linus Walleij wrote:

> On Tue, Sep 10, 2013 at 6:57 PM, Olof Johansson <olof@lixom.net> wrote:
> 
> > I have a very weird experience with snowball right now. I noticed this
> > yesterday when I decided to look at why multi_v7_defconfig doesn't
> > boot on it:
> >
> > * u8500_defconfig doesn't boot as a DT kernel, since the machine ID is
> > still enabled. If I disable the machine ID, it doesn't boot.
> > * Same for multi_v7_defconfig, since that is only DT: It doesn't boot.
> 
> Weird, yeah there is something wrong on Torvalds' HEAD, with
> earlyprint it says:
> 
> Uncompressing Linux... done, booting the kernel.
> Error: unrecognized/unsupported processor variant (0x412fc091).
> This comes from arch/arm/kernel/head-common.S
> 
> I'm trying to bisect and find out what is causing this...

Ah nice. Keep us informed of any progress.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
