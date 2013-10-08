Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3JHC7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:59:37 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63103 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3JHC7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:59:36 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYRT0OwZo5ayKPEYb7NGa_UU7b0x5yojLVL=xHHqkTaug@mail.gmail.com>
References: <1380008771.28920.1.camel@phoenix>
	<1380008861.28920.3.camel@phoenix>
	<CACRpkdYRT0OwZo5ayKPEYb7NGa_UU7b0x5yojLVL=xHHqkTaug@mail.gmail.com>
Date: Tue, 8 Oct 2013 10:59:34 +0800
Message-ID: <CAJxxZ0MUF+_kHg1jmGFnN-6HcUXwswf4zq3uZ78eM2GhgYJ35g@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: adi2: Fix dead lock in adi_gpio_direction_output
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>, Sonic Zhang <sonic.zhang@analog.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Sep 27, 2013 at 8:20 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Sep 24, 2013 at 9:47 AM, Axel Lin <axel.lin@ingics.com> wrote:
>
>> Current code hold port->lock spinlock and then try to grab the lock again
>> in adi_gpio_set_value(). Fix it.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>
> Patch applied, thanks Axel.
>
> Sonic, when you see patches like this please look at and ACK
> them.

Sorry, I am on vacation since Sep. 24.
I will do it in future.

Regards,

Sonic
