Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaLDSKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:10:35 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:37640 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaLDSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:10:31 -0500
MIME-Version: 1.0
In-Reply-To: <20141103122559.GB4538@x1>
References: <1413636974-3244-1-git-send-email-linus.walleij@linaro.org>
	<20141020064605.GB25349@x1>
	<20141024214206.GG19933@dtor-ws>
	<20141103122559.GB4538@x1>
Date: Thu, 4 Dec 2014 19:10:30 +0100
Message-ID: <CACRpkdb45QGkC7aOCMRZ3SH9+effNz1FAGxto6bDR_i7sfZuzw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: stmpe: add pull up/down register offsets for STMPE
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 1:25 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 24 Oct 2014, Dmitry Torokhov wrote:
>
>> On Mon, Oct 20, 2014 at 07:46:05AM +0100, Lee Jones wrote:
>> > On Sat, 18 Oct 2014, Linus Walleij wrote:
>> >
>> > > This adds the register offsets for pull up/down for the STMPE
>> > > 1601, 1801 and 24xx expanders. This is used to bias GPIO lines
>> > > and keypad lines.
>> > >
>> > > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> > > ---
>> > > Hi Sam, Lee: I think you should just ACK this so Dmitry can take the
>> > > patch series through the input tree, where the registers need to be
>> > > used to enable the keypad on the STMPE2401.
>> > > ---
>> > >  drivers/mfd/stmpe.c       | 4 ++++
>> > >  drivers/mfd/stmpe.h       | 3 +++
>> > >  include/linux/mfd/stmpe.h | 2 ++
>> > >  3 files changed, 9 insertions(+)
>> >
>> > Does this need to go in with the other patches in the set?
>> >
>> > I'm _guessing_ that, as you've sent them separately, they can be
>> > applied separately?
>> >
>> > This needs to go in via MFD, but for my own reference:
>> >
>> > Acked-by: Lee Jones <lee.jones@linaro.org>
>>
>> The new register definitions are needed for patch #3.  If you insist on
>> this going through MFD then please take the other 2 patches with my Ack
>> through MFD tree as well I do not think we need the whole song and dance
>> trying to synchronize 2 trees.
>
> Actually, I can't see the other patches as they weren't sent to me.
>
> Please apply them all to your tree with my Ack.

Dmitry can you please apply them so we don't miss this merge window...

Yours,
Linus Walleij
