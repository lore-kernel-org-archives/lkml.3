Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaEPPZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:25:37 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:52191 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbaEPPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:25:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuLqF6d+-BHhFzL+w9bFNxbxWV97dsx1Kbd2GD1PNf3UFg@mail.gmail.com>
References: <1399175125-6430-1-git-send-email-acourbot@nvidia.com>
	<CACRpkdYM5W2oVT0y25u+BhWHpVma5fRP8MgmEH46dAyu8L8-2g@mail.gmail.com>
	<CAAVeFuLqF6d+-BHhFzL+w9bFNxbxWV97dsx1Kbd2GD1PNf3UFg@mail.gmail.com>
Date: Fri, 16 May 2014 17:25:35 +0200
Message-ID: <CACRpkdYPcG-16aeMRKdbqGiz+coXE68p3u_tZNV2cYJgdp6j0g@mail.gmail.com>
Subject: Re: [PATCH] gpio: make of_get_named_gpiod_flags() private
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 3:23 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, May 13, 2014 at 10:17 PM, Linus Walleij
> <linus.walleij@linaro.org> wrote:

>>> This results in all references to gpiod_* functions in of_gpio.h being
>>> gone, which is the way it should be since this file is part of the old
>>> integer GPIO interface.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>
>> This patch broke a lot of drivers so I had to take it out again...
>
> That's unexpected - what happens with it?

I got a horde of mails from Fengguang's autobuilder, I think you got
them as well ... else tell me and I'll dig them up.

Yours,
Linus Walleij
