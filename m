Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaKCM0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:26:11 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33281 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaKCM0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:26:07 -0500
Date: Mon, 3 Nov 2014 12:25:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: stmpe: add pull up/down register offsets for
 STMPE
Message-ID: <20141103122559.GB4538@x1>
References: <1413636974-3244-1-git-send-email-linus.walleij@linaro.org>
 <20141020064605.GB25349@x1>
 <20141024214206.GG19933@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141024214206.GG19933@dtor-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Dmitry Torokhov wrote:

> On Mon, Oct 20, 2014 at 07:46:05AM +0100, Lee Jones wrote:
> > On Sat, 18 Oct 2014, Linus Walleij wrote:
> > 
> > > This adds the register offsets for pull up/down for the STMPE
> > > 1601, 1801 and 24xx expanders. This is used to bias GPIO lines
> > > and keypad lines.
> > > 
> > > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > > ---
> > > Hi Sam, Lee: I think you should just ACK this so Dmitry can take the
> > > patch series through the input tree, where the registers need to be
> > > used to enable the keypad on the STMPE2401.
> > > ---
> > >  drivers/mfd/stmpe.c       | 4 ++++
> > >  drivers/mfd/stmpe.h       | 3 +++
> > >  include/linux/mfd/stmpe.h | 2 ++
> > >  3 files changed, 9 insertions(+)
> > 
> > Does this need to go in with the other patches in the set?
> > 
> > I'm _guessing_ that, as you've sent them separately, they can be
> > applied separately?
> > 
> > This needs to go in via MFD, but for my own reference:
> > 
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> The new register definitions are needed for patch #3.  If you insist on
> this going through MFD then please take the other 2 patches with my Ack
> through MFD tree as well I do not think we need the whole song and dance
> trying to synchronize 2 trees.

Actually, I can't see the other patches as they weren't sent to me.

Please apply them all to your tree with my Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
