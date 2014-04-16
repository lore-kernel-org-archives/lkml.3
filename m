Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbaDPXY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:24:58 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58027 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaDPXYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:24:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=V+xpMEFVqH2Afo8XmCJsUPU2Y8xcmR3rwi+V25KKx8DQ@mail.gmail.com>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
	<1397672724-9063-1-git-send-email-dianders@chromium.org>
	<1397672724-9063-6-git-send-email-dianders@chromium.org>
	<CAPnjgZ2pPa=-L6UxRR3KKF-3Ghi63gEU+5RRybLDHOwKL2cs7Q@mail.gmail.com>
	<CAD=FV=V+xpMEFVqH2Afo8XmCJsUPU2Y8xcmR3rwi+V25KKx8DQ@mail.gmail.com>
Date: Wed, 16 Apr 2014 17:24:55 -0600
X-Google-Sender-Auth: rn1Lnb5UiDXNDRwlsVPYvUL38T0
Message-ID: <CAPnjgZ13C78CoWHnpB5j=FBBQgYfe7+Si+JiUbuaV+ty3u-Oww@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] regulator: tps65090: Make FETs more reliable by
 adding retries
From: Simon Glass <sjg@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Michael Spang <spang@chromium.org>, Sean Paul <seanpaul@chromium.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 16 April 2014 15:25, Doug Anderson <dianders@chromium.org> wrote:
> Simon,
>
> On Wed, Apr 16, 2014 at 1:50 PM, Simon Glass <sjg@chromium.org> wrote:
>>> +#define MAX_CTRL_READ_TRIES    5
>>> +#define MAX_FET_ENABLE_TRIES   1000
>>
>> Gosh that is a lot of tries - should we maybe give up sooner?
>
> That's actually a squash of a recent patch.  See
> <https://chromium-review.googlesource.com/189239>.  I've specifically
> seen at least one case on my device where it needed 888 retries at
> bootup!
>
> ...on my really old Chromebook, it seems to get into a bad state if it
> sits on my desk for a long time.  After I use it a bit it rarely needs
> more than 10 retries.

Try to be kinder to your hardware?

Anyway, fair enough, if you've seen 888 then we need to deal with that case.

Regards,
Simon
