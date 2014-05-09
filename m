Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaEILxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:53:12 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43412 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbaEILxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:53:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4wOdD53Fkf+_CtDqSg5Yvz-1kwaWzMJb357uq5BL9_-7Q@mail.gmail.com>
References: <1398287792-19831-1-git-send-email-linus.walleij@linaro.org>
	<1398287792-19831-2-git-send-email-linus.walleij@linaro.org>
	<CAGsJ_4wOdD53Fkf+_CtDqSg5Yvz-1kwaWzMJb357uq5BL9_-7Q@mail.gmail.com>
Date: Fri, 9 May 2014 13:53:08 +0200
Message-ID: <CACRpkdbieXh8iHSCqai03vNbBZ2_2zV1SscXLY+4T9ZprWJEvQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] RFT: pinctrl: sirf: switch to using allocated state container
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <baohua@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 2:29 PM, Barry Song <baohua@kernel.org> wrote:
> 2014-04-24 5:16 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:

>> This rewrites the SIRF pinctrl driver to allocate a state container
>> for the GPIO chip, just as is done for the pin controller, and
>> use the gpiochip_add_pin_range() to add the range from the gpiochip
>> side rather than adding the range from the pinctrl side.
>>
>> All resulting changes are done in order to pass around a state
>> container rather than refer to a static global object.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Linus, thanks! but this breaks prima2 pinctrl subsystem, do you have an idea?
> otherwise i will do a debug to find the reason.

Unfortunately no :-(

This is the downside of dry-coding ... I rely on others to help out.

See it as a suggestion to what I think should be refactored and how,
I'll keep it on a branch as some "TODO" item for the moment.

Yours,
Linus Walleij
