Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3JIFDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:03:21 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38936 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3JIFDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:03:18 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbx+vJEqz3KQ0EHGt0axRB4JeJh3FF4e+7snbR0HoqKRg@mail.gmail.com>
References: <20131003054104.8941.88857.stgit@localhost>
	<20131003054218.8941.19273.stgit@localhost>
	<20131007173531.GX8949@atomide.com>
	<CACRpkdbx+vJEqz3KQ0EHGt0axRB4JeJh3FF4e+7snbR0HoqKRg@mail.gmail.com>
Date: Wed, 9 Oct 2013 13:03:17 +0800
Message-ID: <CAN1soZwXn5SSgTFQ11PJGK19ZQ==uKcPCF2COpEE_eiMAM13uw@mail.gmail.com>
Subject: Re: [PATCH 3/6] pinctrl: single: Prepare for supporting SoC specific features
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 7:55 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Oct 7, 2013 at 7:35 PM, Tony Lindgren <tony@atomide.com> wrote:
>
>> Hi Linus W,
>>
>> Any comments on the pinctrl patches 3 - 5 in this series?
>
> I have no problems with this patch #3, as it is just changing syntax,
> not semantics.
>
> The problems start with patch #4.
>
> I am tormented with mixed feelings about this, because from one point of
> view I feel it is breaking the promise of pinctrl-single being a
> driver for platforms
> where a pin is controlled by a *single* register.
>
> If this was pinctrl-foo.c I would not have been so much bothered,
> but now it is something that was supposed to be self-contained and
> simple, pertaining to a single register, starting to look like something
> else.
>
> This is a bit like: "oh yeah just one register controls the pins, but under
> some circumstances I also want to mess with this register over here,
> and then this register over there ..." etc.
>
> I'd like Haojian to ACK this to proceed since he's also using this driver
> now. Then I feel better on continuing down this road ...
>
> Then I have a lesser comment on patch #4 since it makes it possible
> for this pin controller to support wake-up interrupt, as I don't see how
> this plays out with front-end GPIO controllers, but let's discuss that
> in the context of that patch.
>
> Yours,
> Linus Walleij
>

I'm OK on both #3 & #4. So Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Regards
Haojian
