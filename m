Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaEVVyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:54:15 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49869 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaEVVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:54:12 -0400
MIME-Version: 1.0
In-Reply-To: <53764045.5090603@codeaurora.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1398759542-13017-1-git-send-email-srinivas.kandagatla@linaro.org>
	<CACRpkdZyEAkJUGC5x6CY65-g97jfyg-TMDoe8JxDMexVx5usSA@mail.gmail.com>
	<5371E8B7.8000103@linaro.org>
	<20140513221313.GI20486@codeaurora.org>
	<CACRpkdZe7NA0CxB=ArWwSRt_BF69sG=BHBz+DY1H4AbabNhC=A@mail.gmail.com>
	<53764045.5090603@codeaurora.org>
Date: Thu, 22 May 2014 23:54:11 +0200
Message-ID: <CACRpkdbex_0jmx5cL0uLcMcGBvhwfAmNssz4xNQuJ+3d=Dv1zg@mail.gmail.com>
Subject: Re: [PATCH v1 01/11] ARM: amba: Add Qualcomm vendor ID.
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 6:43 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 05/16/14 09:24, Linus Walleij wrote:
>> On Wed, May 14, 2014 at 12:13 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>
>>> Please add a note that this id is fake in the commit text or in
>>> the code as well.
>> You just need one of your hardware engineers to add is to one instance
>> of some test chip round so it exists in any hardware whatsoever and it
>> is not "fake" anymore...
>>
>> This is a bit like device tree, it's defined by the kernel community as much
>> as by the hardware engineers and it's a little bit of back-and-forth.
>>
>
> Sure, but hardware teams have moved on from this IP so I doubt we can
> even get them to put it into a test chip. In fact, the devices a
> generation before the ones Srini is working on (msm8660 for example)
> have a periph ID of 0x41180 so we need to override that ID in DT with
> this fake ID for things to even work.

Hehe I wasn't really suggesting doing that.

The point was to illustrate how fragile the border between "real"
and "fake" is in these cases.

Yours,
Linus Walleij
