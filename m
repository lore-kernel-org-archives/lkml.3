Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaE1InS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:43:18 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:38511 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbaE1InP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <5EB3BFCD089AD643B9BB63439F5FD5E9012BF02A09@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1398287792-19831-1-git-send-email-linus.walleij@linaro.org>
	<1398287792-19831-2-git-send-email-linus.walleij@linaro.org>
	<CAGsJ_4wOdD53Fkf+_CtDqSg5Yvz-1kwaWzMJb357uq5BL9_-7Q@mail.gmail.com>
	<CACRpkdbieXh8iHSCqai03vNbBZ2_2zV1SscXLY+4T9ZprWJEvQ@mail.gmail.com>
	<CAGsJ_4ygjo_cUFR8bUoWsGrZYHSubam4WWcb-TjQJNjgy9rvKQ@mail.gmail.com>
	<CACRpkdbQeJwoP7oOzbuhJeuFWxbB5RjFvzqqp8E_1x3=6p-hnQ@mail.gmail.com>
	<5EB3BFCD089AD643B9BB63439F5FD5E9012BF02A09@SHAASIEXM01.ASIA.ROOT.PRI>
Date: Wed, 28 May 2014 10:43:15 +0200
Message-ID: <CACRpkdYng8+Y9jg1qMpwCgqT0SPeM8kr23c1bCQ5Rnvb+wm63g@mail.gmail.com>
Subject: Re: [PATCH 1/2] RFT: pinctrl: sirf: switch to using allocated state container
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <Barry.Song@csr.com>
Cc: Barry Song <baohua@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <DL-SHA-WorkGroupLinux@internal.csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 5:10 PM, Barry Song <Barry.Song@csr.com> wrote:

>>> after moving pinctrl name from sirfsoc-gpio* to dev_name(&pdev->dev) as below:
>>> - err = gpiochip_add_pin_range(&sgpio->chip.gc, "sirfsoc-gpio*",
>>> + err = gpiochip_add_pin_range(&sgpio->chip.gc, dev_name(&pdev->dev),
>>>
>>> Acked-by: Barry Song <Baohua.Song@csr.com>
>
>>Does this mean it works with that change so it's a Tested-by?
>
> yes. with the above change.

OK applied to devel with that change, THANKS Barry, I really like
the looks of the driver better after this change.

Yours,
Linus Walleij
