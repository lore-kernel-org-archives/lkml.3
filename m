Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3D2JFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:05:37 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:54778 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab3D2JFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:05:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130427001210.GA1714@quad.lixom.net>
References: <1366463287-9922-1-git-send-email-linus.walleij@linaro.org>
	<CACRpkdYWSM0BK77qWbQWh0xsN+Ps95Q70zG-GE98MYvThrky2A@mail.gmail.com>
	<20130427001210.GA1714@quad.lixom.net>
Date: Mon, 29 Apr 2013 11:05:35 +0200
Message-ID: <CACRpkdZ6hcNtRkAL6a2SWm-5qCoKDW1KepZeJMqVGE6YnVBUng@mail.gmail.com>
Subject: Re: [PATCH 1/4] clocksource: nomadik-mtu: fix up clocksource/timer
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 2:12 AM, Olof Johansson <olof@lixom.net> wrote:
> On Sat, Apr 20, 2013 at 03:19:43PM +0200, Linus Walleij wrote:
>> On Sat, Apr 20, 2013 at 3:08 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>
>> > The Nomadik clocksource driver has had a bad define making it
>> > impossible to use it for sched_clock() for a while. Fix this
>> > and also enable it for the Nomadik.
>> >
>> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> This one should go to fixes ASAP, could you pick it to your fixes
>> branch? It could be tagged stable if desired - this only affects the
>> Nomadik which works just OK on jiffies so it's really no big regression.
>> The Ux500 does not use the MTU for sched_clock().
>
> Ok, applied on top of next/multiplatform, seems to be what it's based on.
>
> Tagging as stable is up to you as platform owner. :) Since it won't directly
> apply to older kernels you might be better of submitting it to Greg separately.

Oh it's not *that* critical. It is not regressing anything in a bad way,
jiffies work fine. But this is the proper way for the Nomadik long-term.

Yours,
Linus Walleij
