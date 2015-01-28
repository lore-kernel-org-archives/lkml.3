Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbbA1Uaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:30:55 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:54619 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363AbbA1Uaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:30:35 -0500
MIME-Version: 1.0
In-Reply-To: <20150128192700.15269823@linux.lan.towertech.it>
References: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
	<CADcy93WBXjHs8A3Wo4ajiRcM2CHkN0DXSR2uB8Ww5ywe5KTDdA@mail.gmail.com>
	<20150128192700.15269823@linux.lan.towertech.it>
Date: Wed, 28 Jan 2015 10:53:10 -0800
Message-ID: <CALAqxLWh=DzLrUWxNOy=HOrWZSvzK6toWhy=VMkaU6XU-GTmDA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/8] Provide y2038/y2106 safe rtc_class_ops.set_mmss64()
From: John Stultz <john.stultz@linaro.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Xunlei Pang <pang.xunlei@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Henderson <rth@twiddle.net>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:27 AM, Alessandro Zummo <a.zummo@towertech.it> wrote:
> On Thu, 29 Jan 2015 00:12:09 +0800
> Xunlei Pang <pang.xunlei@linaro.org> wrote:
>
>> ping Alessandro
>
>   -EBUSY . saw that, looks fine anyhow, but would like to
>  have a deeper look. we have still some time 'till 2038, right? ;)

While that is true, for folks who are working to deploy systems that
may have 23+ year life times, getting this resolved in the near term
is important.  With so many changes all over the kernel (and then
userspace) pushing back on this "plenty of time" sentiment is
important for this to ever get done.

So yea, if you can't look at it right this second, that's fine, but
please don't put it at the bottom of your todo list for the year. :)

thanks
-john
