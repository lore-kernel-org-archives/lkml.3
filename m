Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaAHIJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:09:09 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42523 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaAHII7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:08:59 -0500
Date: Wed, 8 Jan 2014 08:08:54 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: am335x: IIO/ADC fixes if used together with TSC, v2
Message-ID: <20140108080854.GB19974@lee--X1>
References: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de>
 <20140107085456.GD3182@lee--X1>
 <20140108080359.GA16527@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140108080359.GA16527@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Dmitry, Jonathan,
> > 
> > This is for you.
> > 
> > The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
> > 
> >   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.linaro.org/people/ljones/mfd.git tags/ib-iio-input-3.13-1
> > 
> > for you to fetch changes up to 7ca6740cd1cd410828a01151a044b51910d06eff:
> > 
> >   mfd: input: iio: ti_amm335x: Rework TSC/ADC synchronization (2014-01-07 08:45:00 +0000)
> > 
> > ----------------------------------------------------------------
> > Immutable branch for IIO and Input
> > 
> > ----------------------------------------------------------------
> > Sebastian Andrzej Siewior (5):
> >       iio: ti_am335x_adc: Adjust the closing bracket in tiadc_read_raw()
> >       mfd: ti_am335x_tscadc: Make am335x_tsc_se_update() local
> >       mfd: ti_am335x_tscadc: Don't read back REG_SE
> >       mfd: ti_am335x: Drop am335x_tsc_se_update() from resume path
> >       mfd: input: iio: ti_amm335x: Rework TSC/ADC synchronization
> > 
> >  drivers/iio/adc/ti_am335x_adc.c           | 68 +++++++++++++++++++++++++++++++++++++++++++++++++-------------------
> >  drivers/input/touchscreen/ti_am335x_tsc.c |  4 ++--
> >  drivers/mfd/ti_am335x_tscadc.c            | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
> >  include/linux/mfd/ti_am335x_tscadc.h      |  8 ++++++--
> >  4 files changed, 117 insertions(+), 34 deletions(-)
> 
> I do not have any pending changes to ti_am335x_tsc.c so it can all go
> through Jonathan's tree.

Well the patches are going through my tree, but in case either of you
have any changes to the above files you can merge this and Git will do
the rest during the merge-window. If neither of you do then no need to
pull. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
