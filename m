Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab3K2UJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:09:33 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37886 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab3K2UJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:09:30 -0500
MIME-Version: 1.0
In-Reply-To: <5298F3A1.7070503@metafoo.de>
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com>
	<5295E231.9030200@cisco.com>
	<5295E641.6060603@cogentembedded.com>
	<2150651.hQNra4Rlob@avalon>
	<CACRpkdZQa626hNRFcGvk4t7Z8scTCoEcf7AqO-FsL=BGk6UfeA@mail.gmail.com>
	<52987058.80700@metafoo.de>
	<CACRpkdYuiwH5MzdY3HO7oBSGLqRr5t4HMvGscjsf4QL2G1wiNw@mail.gmail.com>
	<52989B13.8010207@metafoo.de>
	<CACRpkda89fqGd6+ShvFXz-7i56KfG43EggBtjbdKyOCGnJu5Cg@mail.gmail.com>
	<5298F3A1.7070503@metafoo.de>
Date: Fri, 29 Nov 2013 21:09:29 +0100
Message-ID: <CACRpkdbgbb_dcxyaGpdpwiHxd9p1bEc2JB5bzK5dDBHFcHwjzA@mail.gmail.com>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Valentine <valentine.barshak@cogentembedded.com>,
        Hans Verkuil <hansverk@cisco.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Simon Horman <horms@verge.net.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wolfram Sang <wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 9:05 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 11/29/2013 08:52 PM, Linus Walleij wrote:

>> I guess you may be referring to the problem of instatiating
>> a dynamic IRQ chip in *board code* and then passing the
>> obtained dynamic IRQ numbers as resources to the
>> devices also created in a board file?
>>
>
> Yes.
>
>> That would be like you're asking for a function that would
>> return the base of an irq_chip, that needs to be discussed
>> with the irq maintainers, so not much I can say, but maybe
>> I misunderstood this?
>
> I my opinion the best solution for this problem is to have the same lookup
> mechanism we've had for clocks, regulators, etc and now also GPIOs.

Hm this needs to be discussed with some irq people...

Yours,
Linus Walleij
