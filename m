Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab3FUMtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:49:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3FUMtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:49:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/3] ARM: ux500: mop500_snowball_ethernet_clock_enable() removal
Date: Fri, 21 Jun 2013 14:48:50 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
References: <1371545519-27119-1-git-send-email-lee.jones@linaro.org> <CACRpkdbpTMm8FG6KSwvq_7BQRGZ0P=PHHb+WikfRE6JqHv8xpw@mail.gmail.com>
In-Reply-To: <CACRpkdbpTMm8FG6KSwvq_7BQRGZ0P=PHHb+WikfRE6JqHv8xpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306211448.50709.arnd@arndb.de>
X-Provags-ID: V02:K0:ZC1cnCbqFpN4DyFqCZ/pHmjVz6do6k/zCwUAhZJ9S9Q
 004X+mGSX2rK+gWt1uAkWqp6GyHaO2YOyEYgNYxbBrM8cTfII5
 MsU1V1SobNRdIryTVxtPL5ry4IEaCQ8QeWQbDS6JyvgBeijOcs
 Iy3hBIGddcIc2Vb5o6BunENNBLpxv3OsuLorsYbsKd9r7ljG21
 /4+pBzA3U3hA1eivvF7amzJ+c93HvjDuSJTqpvwmnb3QKwZBjU
 Bx1Lck/GTFxAWLo3Ziruj9lJXBPpW7XW/giOrvalBP0puM/lKi
 9GmlIWUGWqXn/imPYD9CExLS71yZnvxcBzKFjF+ifraSBfq4xT
 jzU1A9IlgeVV5wF8N3jw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 June 2013, Linus Walleij wrote:
> On Tue, Jun 18, 2013 at 10:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > As requested by you, this gets rid of  mop500_snowball_ethernet_clock_enable()
> > which is no longer in use. It also straightens out a bug which ensures the
> > SMSC911x's regulator is turned on at start-up when using Device Tree.
> >
> > This is based on your test-merge-20130615 branch.
> 
> All are Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I suggest the ARM SoC folks merge these three patches directly.
> I've queued 1/3 and 2/3 on my devicetree branch so they won't
> be lost, but 3/3 does not apply on any of my branches, it
> needs to be applied directly on some ARM SoC baseline.
> 

Applied to next/drivers, thanks!

	Arnd
