Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbbABK2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:28:53 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47779 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbbABK2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:28:50 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.62.239]
In-Reply-To: <CAPDyKFqGW2NaN+5mUrpBWrhM5ZfUSx70-Yyk9qmNaC1ft_ibpw@mail.gmail.com>
References: <1417563767-32181-1-git-send-email-dianders@chromium.org>
	<CAPDyKFpxvE4x_-PV=KN0HKY5cNug-ss9m5KCjNdebR1LDOJi5w@mail.gmail.com>
	<CAD=FV=UCyOXfMqu_MYbd5pKOpgXPB87LQ7hCegeeY9vzsy6QAg@mail.gmail.com>
	<CAPDyKFqGW2NaN+5mUrpBWrhM5ZfUSx70-Yyk9qmNaC1ft_ibpw@mail.gmail.com>
Date: Fri, 2 Jan 2015 11:28:48 +0100
Message-ID: <CABxcv==1w1GAHNCaNnh+e-xaYo8xtuD8dywTseioosxT4GZOvg@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Fixes for SDIO interrupts for dw_mmc
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Tony Lindgren <tony@atomide.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>,
        Joe Perches <joe@perches.com>, Axel Lin <axel.lin@ingics.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ulf,

On Tue, Dec 30, 2014 at 11:29 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 19 December 2014 at 20:02, Doug Anderson <dianders@chromium.org> wrote:
>>
>>> It was a bit hard to follow the
>>> updated the revisions, please don't send patches "in-reply-to" for
>>> future sets.
>>
>> Very strange.  I didn't send out anything in-reply-to other than what
>> git-send-email usually does.  I believe I had:
>>
>> [0] - no in reply to.
>>  [1] - in reply to [0]
>>  [2] - in reply to [0]
>>  [3] - in reply to [0]
>>  [4] - in reply to [0]
>
> That's good. As long as there are no in-reply to previous versions of
> patches/patchsets.
>
> I am using gmails web-based client so it could very well be that it
> does some magic, which I am not yet aware of.
>

I think that you were confused because Gmail's "conversation view"
groups emails in a thread not by the email subject but by the email
body.

So if a new revision of a series is sent and a patch did not change
from the previous version, Gmail will add it to the old patch thread
since the body is basically the same even when a version is present in
the subject (e.g: PATCH v2 foo).

I found that annoying as well so I disabled conversation view going to
Gmail's settings -> General -> Conversation view off

Hope it helps.

Best regards,
Javier
