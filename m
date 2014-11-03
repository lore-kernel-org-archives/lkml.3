Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaKCJ1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:27:11 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34663 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaKCJ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:27:09 -0500
MIME-Version: 1.0
In-Reply-To: <58957675.Bh6LToE4gg@dtor-glaptop>
References: <1413636974-3244-1-git-send-email-linus.walleij@linaro.org>
	<20141020064605.GB25349@x1>
	<CACRpkdbsswGBy69+EGJTbTpxD7j2FnruyGdyUZRBVtt-JaScfg@mail.gmail.com>
	<58957675.Bh6LToE4gg@dtor-glaptop>
Date: Mon, 3 Nov 2014 10:27:08 +0100
Message-ID: <CACRpkdYNBZdB14fjj0LnQ8GchaGLTgfpvxhe4J9nc3XF80dFgQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: stmpe: add pull up/down register offsets for STMPE
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 8:31 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wednesday, October 29, 2014 10:55:14 AM Linus Walleij wrote:
>> On Mon, Oct 20, 2014 at 8:46 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> > On Sat, 18 Oct 2014, Linus Walleij wrote:
>> >> This adds the register offsets for pull up/down for the STMPE
>> >> 1601, 1801 and 24xx expanders. This is used to bias GPIO lines
>> >> and keypad lines.
>> >>
>> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> >> ---
>> >> Hi Sam, Lee: I think you should just ACK this so Dmitry can take the
>> >> patch series through the input tree, where the registers need to be
>> >> used to enable the keypad on the STMPE2401.
>> >> ---
>> >>
>> >>  drivers/mfd/stmpe.c       | 4 ++++
>> >>  drivers/mfd/stmpe.h       | 3 +++
>> >>  include/linux/mfd/stmpe.h | 2 ++
>> >>  3 files changed, 9 insertions(+)
>> >
>> > Does this need to go in with the other patches in the set?
>> >
>> > I'm _guessing_ that, as you've sent them separately, they can be
>> > applied separately?
>>
>> No sorry if it was unclear, the series need to go in toghether.
>> So this patch adds some infrastructure to the MFD device which
>> is then utilized by the input driver in a later patch.
>>
>> > This needs to go in via MFD, but for my own reference:
>> >
>> > Acked-by: Lee Jones <lee.jones@linaro.org>
>>
>> Dmitry can you merge this & the rest with Lee's ACK?
>
> I'd be delighted, but it _sounded_ like Lee wanted it to go though MFD?

Lee, can Dmitry take these through input?

Yours,
Linus Walleij
