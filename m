Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab3BXWme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:42:34 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:64363 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759403Ab3BXWmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:42:33 -0500
MIME-Version: 1.0
In-Reply-To: <201302242334.42408.heiko@sntech.de>
References: <201302231855.47560.heiko@sntech.de>
	<201302231856.35083.heiko@sntech.de>
	<CACRpkdbA-S7qYHnN72c65Wo_Q7qD3tUxUSNYEXkk4gHbpez4+Q@mail.gmail.com>
	<201302242334.42408.heiko@sntech.de>
Date: Sun, 24 Feb 2013 23:42:32 +0100
Message-ID: <CACRpkdbKFWcT_Oa00nd_Op5ndOEc-cEkZm6fzHRuxs0Rc+ZOeA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: return real error codes when pinctrl is not included
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Tomasz Figa <t.figa@samsung.com>, Prathyush K <prathyush@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 11:34 PM, Heiko Stübner <heiko@sntech.de> wrote:

> [Me]
>> This make me suspect that you have this ugly patch in some
>> private repo and I will be seeing it again and again :-(
>
> All my s3c24xx work is done is my spare time, so I have to confess I came up
> with this "ugly patch" all by myself when working on dt support for my machine
> and stumbling upon the described problem with the pin configuration.
>
> So, as it is obviously wrong, I also won't hold onto it.
>
> In any case, thanks for the thorough explanation, which I probably won't
> forget anytime soon.

Hm, maybe I have come across as too harsh and then I feel bad about
that :-(

I really want spare-time contributors, they are often more valueable
in addition to the corporate ones since they provide an outside view
of things.

Yours,
Linus Walleij
