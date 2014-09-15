Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaIOK75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:59:57 -0400
Received: from exprod7og128.obsmtp.com ([64.18.2.121]:49258 "EHLO
	exprod7og128.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbaIOK7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:59:55 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZfzsg-upNJaWX5CO6dJn3mg=wzhKhX-koask4ckxVTmQ@mail.gmail.com>
References: <1410360030-26634-1-git-send-email-anders.berg@avagotech.com>
	<CACRpkdavQBJkaC40GJkD396JkwPjSr_dzWegn8veLpG-Fcn-SQ@mail.gmail.com>
	<CAE0=X_1YMs1OUx3H65qbZ9CX-oSiW4Uo65Z7qCW8-6ksc4ovvQ@mail.gmail.com>
	<CACRpkdZfzsg-upNJaWX5CO6dJn3mg=wzhKhX-koask4ckxVTmQ@mail.gmail.com>
Date: Mon, 15 Sep 2014 12:59:54 +0200
Message-ID: <CAE0=X_1Rh_XWKoR+wn=uz+hcKZtKtq+7eE_Q3QAEHoyfXCX57g@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: Add support for chip select extension
From: Anders Berg <anders.berg@avagotech.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 7:00 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Sep 11, 2014 at 10:10 PM, Anders Berg <anders.berg@avagotech.com> wrote:
(...)
>> I picked 0xb6 since I've seen some reference manuals for other AMBA
>> peripherals the use of JEDEC assigned vendor IDs in this register field (see
>> the PL390 TRM for example). So I put the LSI Logic 7-bit JEDEC ID (0x36)
>> there: [0:6] = 0x36, [7] = 1 (the MSB set to '1' to signify the use of JEDEC
>> ID instead of a "classic" AMBA vendor).
>
> Hey that's very observant, I had no clue about that scheme!
>
> Can you write a comment about this in <linux/amba/bus.h> when
> you patch it (like above the enum) so we know that in the future
> when people need to pick new IDs?

Sure, will do.

/Anders
