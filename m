Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaJ2Tbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:31:38 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42828 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaJ2Tbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:31:36 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: stmpe: add pull up/down register offsets for STMPE
Date: Wed, 29 Oct 2014 12:31:31 -0700
Message-ID: <58957675.Bh6LToE4gg@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-37-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CACRpkdbsswGBy69+EGJTbTpxD7j2FnruyGdyUZRBVtt-JaScfg@mail.gmail.com>
References: <1413636974-3244-1-git-send-email-linus.walleij@linaro.org> <20141020064605.GB25349@x1> <CACRpkdbsswGBy69+EGJTbTpxD7j2FnruyGdyUZRBVtt-JaScfg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 29, 2014 10:55:14 AM Linus Walleij wrote:
> On Mon, Oct 20, 2014 at 8:46 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Sat, 18 Oct 2014, Linus Walleij wrote:
> >> This adds the register offsets for pull up/down for the STMPE
> >> 1601, 1801 and 24xx expanders. This is used to bias GPIO lines
> >> and keypad lines.
> >> 
> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >> ---
> >> Hi Sam, Lee: I think you should just ACK this so Dmitry can take the
> >> patch series through the input tree, where the registers need to be
> >> used to enable the keypad on the STMPE2401.
> >> ---
> >> 
> >>  drivers/mfd/stmpe.c       | 4 ++++
> >>  drivers/mfd/stmpe.h       | 3 +++
> >>  include/linux/mfd/stmpe.h | 2 ++
> >>  3 files changed, 9 insertions(+)
> > 
> > Does this need to go in with the other patches in the set?
> > 
> > I'm _guessing_ that, as you've sent them separately, they can be
> > applied separately?
> 
> No sorry if it was unclear, the series need to go in toghether.
> So this patch adds some infrastructure to the MFD device which
> is then utilized by the input driver in a later patch.
> 
> > This needs to go in via MFD, but for my own reference:
> > 
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> Dmitry can you merge this & the rest with Lee's ACK?

I'd be delighted, but it _sounded_ like Lee wanted it to go though MFD?

Thanks.

-- 
Dmitry
