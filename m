Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3FPAEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 20:04:47 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:39208 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3FPAEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 20:04:45 -0400
MIME-Version: 1.0
In-Reply-To: <1422045.RvRkWGR9K7@avalon>
References: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1795038.rqcr6GWLdP@avalon>
	<CACRpkdYi=ekV8okmz68HZ8Ydv9hTrHnHvQh0HYMs5SfURd9mdA@mail.gmail.com>
	<1422045.RvRkWGR9K7@avalon>
Date: Sun, 16 Jun 2013 02:04:45 +0200
Message-ID: <CACRpkdZePYMHFMOc0WEy73vqix9uRFyedS66sKcyP_D_Kq+nQg@mail.gmail.com>
Subject: Re: [RFC] pinctrl: generic: Add DT bindings
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 1:52 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Linus,
> On Sunday 16 June 2013 01:51:32 Linus Walleij wrote:

>> As dicussed earlier this was designed for systems where
>> you could set the pull-up resistance, like
>>
>> bias-pull-up = <600000>;
>>
>> would give 600kOhm pull up.
>>
>> In most existing systems that is silly, as they can't specify it, so they
>> should be able to do just:
>>
>> bias-pull-up;
>>
>> as that is all they can do. If we have to cut one way, we should cut the
>> former until such a system appears.
>
> I'm fine with bias-pull-up = <1>; vs bias-pull-up;. What bothers me a bit is
> bias-pull-up = <0>; vs bias-disable;.

Oh yeah OK you got a point there for sure.

Setting bias-pull-up = <0>; would be equal to short-circuit
so it does not make any kind of sense.

Let's keep an eye on this.

Yours,
Linus Walleij
