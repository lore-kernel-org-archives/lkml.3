Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3KRKAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:00:46 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37268 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3KRKAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <CANqRtoQA0dXPs8+sNS-8WBPLpzvbSuwj0J3967He0rm=QwNCMQ@mail.gmail.com>
References: <20131106234737.8971.37405.sendpatchset@w520>
	<CACRpkdZC+hvChpDMasj0avRTTbprVn8ro7NxywNUPw+SOr10bw@mail.gmail.com>
	<CANqRtoQA0dXPs8+sNS-8WBPLpzvbSuwj0J3967He0rm=QwNCMQ@mail.gmail.com>
Date: Mon, 18 Nov 2013 11:00:38 +0100
Message-ID: <CACRpkdaMj6jnnVCSdezFH7p=S5zUFrKnjN9dSr7_+2k7dbq9ZA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas RZ GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 7:19 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> On Wed, Nov 13, 2013 at 4:59 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Thu, Nov 7, 2013 at 12:47 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>>
>> Is it so that arch/sh is more soft on this for example...?
>> Can some arch maintainer like SH/Paul ACK this approach?
>>
>> Read: SH is not moving to device tree...?
>
> From what I can tell this GPIO block is not used with SH, so I don't
> think SH is related, but regarding DT on SH, do you know when it was
> decided that other architectures also were supposed to move DT?

I don't think these is any such decision, I'm just asking. I know
that we only want to see DT on new archs and old hairy board code
should be ridded using DT ... So I just want to know what the
situation is like wrt Super-H.

>>> Tested with yet-to-be-posted platform device and DT devices on
>>> r7s72100 and Genmai using LEDs, DIP switches and I2C bitbang.
>>
>> Do you think the maintainers will merge the platform
>> device approach?
>
> I would not assume so. But the goal with these patches is  not
> upstream, instead they basically serve as a stop-gap solution between
> now and when I get OK that the DT bits in this GPIO driver looks fine.
> If they are going to be merged or not is a different question IMO.

Um so as an upstream maintainer I don't really know what to do
at this point :-)

But a DT-only driver is uncontroversial so I'd merge that.

> I'll ditch the platform data interface and post a V2.

Okay that sounds good...

Thanks,
Linus Walleij
