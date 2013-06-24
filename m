Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3FXMYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:24:14 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44479 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3FXMYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:24:12 -0400
MIME-Version: 1.0
In-Reply-To: <201306220139.28794.heiko@sntech.de>
References: <1371379548-6482-1-git-send-email-linus.walleij@stericsson.com>
	<51C4A447.3090807@wwwdotorg.org>
	<3185376.o7RqphCDfQ@avalon>
	<201306220139.28794.heiko@sntech.de>
Date: Mon, 24 Jun 2013 14:24:12 +0200
Message-ID: <CACRpkdYMe+q2GUXooSeVVua3-AHDJFfWQu21bn45b_omsA7FAQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: establish pull-up/pull-down terminology
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 1:39 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Samstag, 22. Juni 2013, 01:30:18 schrieb Laurent Pinchart:
>> [Stephen]
>> > IIRC the idea of the PULL_PIN_DEFAULT was to avoid having to specify
>> > UP/DOWN for each pin/group, but could just say "default", which would
>> > then reduce the number of pinctrl mapping table entries or pinctrl DT
>> > property entries.
>>
>> I may be mistaken, but I've understood the PULL_PIN_DEFAULT option as a way
>> to select the default bias configuration when the default value is
>> hardware- controlled, not as a pure software option.
>
> Yep that was the original intent ... to handle hardware that hides the
> complete logic from the software and you only get to turn it on or off, while
> the direction and other params are determined internally for example by the
> pin function.

Heiko, can you send a documentation patch to clarify this so we
don't get any misunderstandings?

Maybe it'd be useful for software purposes as well, but let's save
that for when it gets used like that.

Yours,
Linus Walleij
