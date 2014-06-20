Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934745AbaFTHjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:39:05 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64539 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934161AbaFTHjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:39:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140618122438.GR19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-17-git-send-email-wens@csie.org> <20140618082953.GO21030@lee--X1>
 <20140618122438.GR19730@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 20 Jun 2014 15:38:38 +0800
X-Google-Sender-Auth: 30zBVTeV0WyE_6xlZuwC0FidAKU
Message-ID: <CAGb2v67M1FV8UPrg8bK9HDz6v72pL8-G97b-PHtOtCFurPjyrw@mail.gmail.com>
Subject: Re: [PATCH v2 16/20] mfd: sun6i-prcm: Add support for Allwinner A23 PRCM
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 8:24 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Wed, Jun 18, 2014 at 09:29:53AM +0100, Lee Jones wrote:
>> > The Allwinner A23 SoC has a PRCM unit like the previous A31 SoC.
>> > The differences are the AR100 clock can no longer be modified,
>> > the APB0 clock has different divisors, and some clock gates are
>> > gone.
>> >
>> > This patch adds a compatible with a modified subdevice list for
>> > the A23.
>> >
>> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> > ---
>> >  .../devicetree/bindings/mfd/sun6i-prcm.txt         |  2 +-
>> >  drivers/mfd/sun6i-prcm.c                           | 30 ++++++++++++++++++++++
>> >  2 files changed, 31 insertions(+), 1 deletion(-)
>>
>> The patch looks fine to me, but I'm concerned about the size of the
>> patch set and the amount of subsystems it touches.
>>
>> I am guessing that this patch can just be taken independently though.
>> Please correct me if I'm wrong.
>
> I have a bit of the same concern. We have several comments on the
> previous patches, so I'm not even sure this patch can go as is.
>
> It would be much easier if you (ChenYu) could introduce first a very
> basic with just the UART support, and then, as separate series,
> clocks, PRCM, MMC, and so on.

OK. I will do that. I'll also try to send some of the independent
fixes separately.


ChenYu
