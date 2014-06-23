Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaFWJ04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:26:56 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60289 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaFWJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:26:55 -0400
Date: Mon, 23 Jun 2014 10:26:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: cros_ec_spi: set wakeup capability
Message-ID: <20140623092650.GE8847@lee--X1>
References: <1402953143-24681-1-git-send-email-dianders@chromium.org>
 <20140618092012.GF23945@lee--X1>
 <CAD=FV=UiA=bsvune6A=wq+zKFq1+pkem0gTa-utxmBB6tKYM=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=UiA=bsvune6A=wq+zKFq1+pkem0gTa-utxmBB6tKYM=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lee (-others),

Re-CC'ing the list.

> On Wed, Jun 18, 2014 at 2:20 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >> From: Prathyush K <prathyush.k@samsung.com>
> >>
> >> Set the device as wakeup capable and register the wakeup source.
> >>
> >> Note: Though it makes more sense to have the SPI framework do this,
> >> (either via device tree or by board_info)
> >> this change is as per an existing mail chain:
> >> https://lkml.org/lkml/2009/8/27/291
> >>
> >> Signed-off-by: Prathyush K <prathyush.k@samsung.com>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >> Note that I don't have suspend/resume actually working upstream, but I
> >> see that /sys/bus/spi/drivers/cros-ec-spi/spi2.0/power/wakeup exists
> >> with this patch and doesn't exist without it.
> >
> > Very well.  Applied, thanks.
> 
> Thanks for applying!  ...did this go in some non-standard branch?  I
> see another of my patches got committed to your "for-mfd-next" tree on
> the 19th but I don't see this one...

Patience Grasshopper.  When I say that it's applied, it means that I
have done so locally only.  After I've collected a few local patches
I'll usually then fix them all with with my SoB and push them out to
the public MFD tree.

BTW, it's always best to leave the ML in as CC, so others can see the
answer to these types of questions.  It may save a few emails a year,
but every little helps. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
