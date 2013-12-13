Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab3LMIMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:12:55 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50244 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3LMIMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:12:53 -0500
MIME-Version: 1.0
In-Reply-To: <52AA6909.8050200@inov.pt>
References: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt>
	<CACRpkdYbCzOJ9k8AyriM9quafx=dseK6w1DYjyrJ9F53ka8TEw@mail.gmail.com>
	<52AA6909.8050200@inov.pt>
Date: Fri, 13 Dec 2013 09:12:52 +0100
Message-ID: <CACRpkdbBqqbkp3ap3Y=C5zC3Cq9jd+dL4iPZ9-2-Fd81GLAPBA@mail.gmail.com>
Subject: Re: [PATCH] ARM: S3C24XX: Fix configuration of gpio port sizes on S3C24XX.
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 2:55 AM, José Miguel Gonçalves
<jose.goncalves@inov.pt> wrote:
> On 27-09-2013 15:17, Linus Walleij wrote:
>> On Wed, Sep 11, 2013 at 10:46 AM, José Miguel Gonçalves
>> <jose.goncalves@inov.pt> wrote:
>>
>>> Some GPIO line limits are incorrectly set which, for instance,
>>> does not allow nRTS1 (GPH11) configuration on a S3C2416 chip.
>>>
>>> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
>>> ---
>>>   arch/arm/mach-s3c24xx/include/mach/gpio.h |   10 +++++-----
(...)
>
> Was this patch forgotten?

Not by me, I just never got an ACK from the Samsung maintainers,
so I can't apply it to the GPIO tree.

Ben, Kukjin: can one of you ACK this so I can take it through the
GPIO tree?

Yours,
Linus Walleij
