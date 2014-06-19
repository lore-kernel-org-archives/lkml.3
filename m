Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbaFSQRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:17:35 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:51996 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbaFSQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <53A309A5.9040204@linaro.org>
References: <1403091060-5054-1-git-send-email-amit.daniel@samsung.com>
	<CAD=FV=WHK7TDdqcAd6aVs2g8rcHJx834im_4nTKHJAkUisWq4A@mail.gmail.com>
	<53A2A86E.4090903@linaro.org>
	<CAD=FV=VUomY-h2euRVWNO=ND0pUNLO5mZr_=sMm_oUSrwBssnA@mail.gmail.com>
	<53A309A5.9040204@linaro.org>
Date: Thu, 19 Jun 2014 09:17:32 -0700
X-Google-Sender-Auth: W9svIXIzHHBJPCb5WQmofcHLm-Q
Message-ID: <CAD=FV=X0NHALPJWaszKLCLPFY-xJvT7iio=hvQCeqCz5O5c-MQ@mail.gmail.com>
Subject: Re: [PATCH] clocksource: exynos-mct: Register the timer for stable udelay
From: Doug Anderson <dianders@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Riley <davidriley@chromium.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Thu, Jun 19, 2014 at 9:02 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
>> My understanding of the current status is:
>> * I posed the 64-bit version that's almost as fast as the 32-bit version.
>> * I asked if people want the 32-bit version: no answer
>> * I asked if anyone is opposed to the 64-bit version: no answer
>
>
> Yeah, that happens. I thought you were working on the 32 bits.

It was on my list of things to do today to touch base and make sure we
were on the same page.  Apparently we weren't.  ;)


>> I know that you wanted me to clean up the description of the 64-bit
>> version so I was going to do that and repost.  If there's someone
>> willing to review / ack the 32-bit version I'd be happy to do that
>> instead.  Possibly I'll do both and a maintainer can choose which to
>> apply?
>
>
> Please, resend me the patch 1/3 as it is urgent with the changelog changed.

OK, I'll do that right now, but just send it as a single patch (so I
can get it out right away).  Then I'll post up the 32-bit versions
with an implicit dependency on that patch.

-Doug
