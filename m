Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3FPMrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 08:47:22 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36968 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab3FPMrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 08:47:20 -0400
MIME-Version: 1.0
In-Reply-To: <2614957.8jBPZazWeB@flatron>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
	<9948950.GZ51yJYkxQ@flatron>
	<15dd01ce6887$f3d6d720$db848560$%kim@samsung.com>
	<2614957.8jBPZazWeB@flatron>
Date: Sun, 16 Jun 2013 14:47:20 +0200
Message-ID: <CACRpkdaz2YXGvs3uoz0_8MXABWSWfswkhStNGX5Et4vmumnEzA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 1:03 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Friday 14 of June 2013 07:47:15 Kukjin Kim wrote:
>> Tomasz Figa wrote:
>> > On Thursday 13 of June 2013 10:05:44 Doug Anderson wrote:
>> > > It's convenient if get_maintainer suggests sending samsung/exynos
>> > > pinctrl changes to linux-samsung-soc and to Kukjin.  Add an entry
>> > > for
>> > > that.
>> >
>> > Well, if we are already at it, we could list the actual maintainers of
>> > the driver.
>> >
>> > The original maintainer was Thomas Abraham <thomas.abraham@linaro.org>
>>
>> Should be original author?! I think, original maintainer was/is Linus
>> Walleij.
>
> Linus is the maintainer of the pin control subsystem. In addition drivers
> can have their own maintainers, but of course they are lower in the
> hierarchy than subsystem maintainers.

Well I don't really like hiearchies, as I'm basically anarchist :-P

Anyway, as long as the get-mainater script output both Thomas
and my name I don't really care, the only practical intent with
this file is to be able to mail the right people.

Yours,
Linus Walleij
