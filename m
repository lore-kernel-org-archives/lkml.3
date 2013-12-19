Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3LSIs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:48:56 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:58839 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab3LSIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:48:52 -0500
Date: Thu, 19 Dec 2013 08:48:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: am335x: IIO/ADC fixes if used together with TSC
Message-ID: <20131219084847.GD2621@lee--X1>
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
 <d916c9be-2614-41b8-ae92-67bf1a57ed74@email.android.com>
 <52B1EAC5.4020104@linutronix.de>
 <a3513779-5ede-4e33-b29d-0cc8e73f8282@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3513779-5ede-4e33-b29d-0cc8e73f8282@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Given timing I suspect that by the we have reviewed these will be too
> >late in this cycle so will hit in the merge window plus stable.
> >> 
> >> Also some of these are cleanups rather than fixes so should normally
> >be separate from fixes and applied after them as they are not 
> >> Stable material.
> >
> >I tried to keep 5/5 as small as possible so I factor individual and
> >separate changes as good as possible as long as the drivers remained
> >functional. That means 1-4 are mostly pre-work for 5/5 and that makes
> >5/5 depends on them.
> >
> >Tagging 5/5 stable I would prefer to take 1-4, too to keep the backport
> >effort small. The clash due to the continues mode which is v3.13 is
> >probably small. This said, I think it is the best to backport it stable
> >if someone asks for it (unless the majority here thinks otherwise).
> >
> >Are you saying this is too late for v3.13 or v3.14-rc1?
> >
> >Sebastian
> 
> Too late for 3.13. Probably fine for next merge window if reviews are all good or as a
>  fix post 3.14-rc1 of it misses the cutoff for the merge window.

I think this set should go in via -next. So it will hit the v3.14
merge window.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
